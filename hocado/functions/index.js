/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Import các thư viện cần thiết
// const {onRequest} = require("firebase-functions/https");
const {setGlobalOptions} = require("firebase-functions/v2");
const {onDocumentCreated, onDocumentUpdated, onDocumentDeleted} =
        require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging"); // Dùng cho FCM
const {onSchedule} = require("firebase-functions/v2/scheduler");
const logger = require("firebase-functions/logger");

setGlobalOptions({maxInstances: 10});

// Khởi tạo Firebase Admin SDK
initializeApp();
const db = getFirestore();

/**
 * Trigger này tự động chạy mỗi khi một document MỚI được tạo
 * trong collection 'LearningActivities'.
 */
exports.aggregateDailyStats =
onDocumentCreated("learning_activities/{activityId}", async (event) => {
  // 1. Ghi log (để debug)
  logger.info(`New activity received: ${event.params.activityId}`);

  // 2. Lấy dữ liệu từ document vừa được tạo
  const data = event.data.data();

  // 3. (QUAN TRỌNG) Chỉ xử lý nếu là 'study_session'
  if (data.type !== "studySession") {
    logger.log("Activity is not a study session, skipping aggregation.");
    return null; // Kết thúc function
  }

  // 4. Lấy các thông tin cần thiết
  const {
    uid,
    timestamp,
    durationMinutes,
    cardsReviewed,
    cardsCorrect,
    cardsIncorrect,
    newCardsLearned,
  } = data;

  // Kiểm tra dữ liệu
  if (!uid || !timestamp) {
    logger.error("Activity data is missing 'uid' or 'timestamp'", data);
    return null;
  }

  // 5. Tính toán ngày (sử dụng UTC cho nhất quán)
  // Chuyển Firebase Timestamp (server-side) thành đối tượng Date
  const activityDate = timestamp.toDate();

  // Tạo chuỗi YYYY-MM-DD (ví dụ: "2025-11-09")
  const yyyy = activityDate.getUTCFullYear();
  const mm = String(activityDate.getUTCMonth() + 1)
      .padStart(2, "0"); // Tháng (0-11)
  const dd = String(activityDate.getUTCDate()).padStart(2, "0");
  const dateString = `${yyyy}-${mm}-${dd}`;

  // Tạo đối tượng Date cho 00:00:00 UTC của ngày đó
  const dateForField = new Date(Date.UTC(yyyy, activityDate.getUTCMonth(), dd));

  // 6. Xác định Document ID cho 'DailyLearningStats'
  const statDocId = `${uid}_${dateString}`;
  const statDocRef = db.collection("daily_learning_stats").doc(statDocId);

  // 7. (CỐT LÕI) Chạy một Giao Dịch (Transaction)
  // Transaction đảm bảo rằng nếu 2 phiên học kết thúc cùng lúc,
  // dữ liệu vẫn được cộng dồn chính xác, không bị ghi đè.
  try {
    await db.runTransaction(async (transaction) => {
      // Đọc document thống kê hiện tại
      const statDoc = await transaction.get(statDocRef);

      if (!statDoc.exists) {
        // TRƯỜNG HỢP 1: Tài liệu chưa tồn tại (Hoạt động đầu tiên trong ngày)
        logger.info(`Creating new daily stat doc: ${statDocId}`);
        transaction.set(statDocRef, {
          uid: uid,
          date: dateForField, // Lưu lại timestamp 00:00:00 UTC
          totalMinutesStudied: durationMinutes || 0,
          totalCardsReviewed: cardsReviewed || 0,
          totalCorrect: cardsCorrect || 0,
          totalIncorrect: cardsIncorrect || 0,
          totalNewCardsLearned: newCardsLearned || 0,
        });
      } else {
        // --- TRƯỜNG HỢP 2: Tài liệu đã tồn tại (Cộng dồn giá trị) ---
        logger.info(`Incrementing existing daily stat doc: ${statDocId}`);
        // Sử dụng FieldValue.increment() để cộng dồn an toàn
        transaction.update(statDocRef, {
          totalMinutesStudied: FieldValue.increment(durationMinutes || 0),
          totalCardsReviewed: FieldValue.increment(cardsReviewed || 0),
          totalCorrect: FieldValue.increment(cardsCorrect || 0),
          totalIncorrect: FieldValue.increment(cardsIncorrect || 0),
          totalNewCardsLearned: FieldValue.increment(newCardsLearned || 0),
        });
      }
    });

    logger.info(`Successfully aggregated stats for doc: ${statDocId}`);
  } catch (error) {
    logger.error(`Error during transaction for ${statDocId}:`, error);
  }

  return null; // Kết thúc function thành công
});

// Trigger: Chạy mỗi khi có document được TẠO trong 'notifications'
exports.sendNotificationOnCreate = onDocumentCreated(
    "users/{userId}/notifications/{notificationId}",
    async (event) => {
      const notificationData = event.data.data();
      const userId = event.params.userId;

      logger.info("Received notification data:", notificationData);

      if (!notificationData) return;

      try {
        const userDoc = await db.collection("users").doc(userId).get();
        const fcmToken = userDoc.data().fcmToken;

        if (!fcmToken) {
          logger.warn(`No FCM token for user ${userId}`);
          return;
        }

        const messagePayload = {
          token: fcmToken,
          notification: {
            title: notificationData.title,
            body: notificationData.message,
          },
          data: {
            nid: notificationData.nid || "",
            type: notificationData.type || "system",
            // Chuyển mọi dữ liệu metadata thành string để tránh lỗi FCM
            route: notificationData.route || "/",
          },
          android: {priority: "high"},
          apns: {payload: {aps: {sound: "default", badge: 1}}},
        };

        await getMessaging().send(messagePayload);
      } catch (error) {
        logger.error("Error sending notification", error);
      }
    });

// Gửi nhắc nhở mỗi 8h tối.
exports.dailyStudyReminderTopic = onSchedule({
  schedule: "0 20 * * *",
  timeZone: "Asia/Ho_Chi_Minh",
}, async (event) => {
  const message = {
    topic: "daily_learners", // Topic mà user đã đăng ký
    notification: {
      title: "Đến giờ học rồi!",
      body: "Vào ôn tập Flashcard ngay nào 🚀",
    },
    data: {
      type: "reminder",
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
    android: {priority: "high"},
    apns: {payload: {aps: {sound: "default"}}},
  };

  try {
    const response = await getMessaging().send(message);
    logger.info("Successfully sent daily reminder via Topic:", response);
  } catch (error) {
    logger.error("Error sending topic message:", error);
  }
});

// Trigger: +1 noti chưa đọc cho user nếu có noti mới được tạo
exports.incrementUnreadCount = onDocumentCreated(
    "users/{userId}/notifications/{notificationId}",
    async (event) => {
      const newNoti = event.data ? event.data.data() : null;
      if (!newNoti) return;

      // Chỉ cộng nếu thông báo mới có trạng thái là chưa đọc
      if (newNoti.isRead === false) {
        const userId = event.params.userId;

        const userRef = db.collection("users").doc(userId);

        try {
          // Dùng update gọn hơn set({merge: true}) nếu user chắc chắn tồn tại
          await userRef.update({
            unreadCount: FieldValue.increment(1),
          });
        } catch (error) {
          console.error(`Failed to increment count for ${userId}:`, error);
        }
      }
    },
);

/**
* 2. KHI CẬP NHẬT TRẠNG THÁI THÔNG BÁO (UPDATE)
 * - Từ Chưa đọc -> Đã đọc: Giảm count -1
 * - Từ Đã đọc -> Chưa đọc: Tăng count +1
*/
exports.updateUnreadCount = onDocumentUpdated(
    "users/{userId}/notifications/{notificationId}", async (event) => {
      const userId = event.params.userId;

      // Lấy dữ liệu TRƯỚC và SAU khi update
      const oldNoti = event.data.before.data();
      const newNoti = event.data.after.data();

      // Logic kiểm tra sự thay đổi của isRead
      let change = 0;

      // Trường hợp 1: Đang 'chưa đọc' -> chuyển thành 'đã đọc'
      // Truong hop 2: Đang 'đã đọc' -> chuyển thanh 'chưa đọc'
      if (oldNoti.isRead === false && newNoti.isRead === true) {
        change = -1;
      } else if (oldNoti.isRead === true && newNoti.isRead === false) {
        change = 1;
      }

      // Nếu có sự thay đổi thì mới cập nhật vào User
      if (change !== 0) {
        await db.collection("users").doc(userId).update({
          unreadCount: FieldValue.increment(change),
        });
        logger.info(`Updated unread count for user ${userId} by ${change}`);
      }
    },
);

/**
 * 3. KHI XÓA THÔNG BÁO (DELETE)
 * - Nếu xóa một thông báo đang "chưa đọc" -> Giảm count -1
 * - Nếu xóa thông báo "đã đọc" rồi thì không làm gì cả.
 */
exports.decrementUnreadCountOnDelete = onDocumentDeleted(
    "users/{userId}/notifications/{notificationId}", async (event) => {
      const userId = event.params.userId;
      const deletedNoti = event.data ? event.data.data() : null;

      // Chỉ giảm nếu cái thông báo vừa bị xóa đó đang ở trạng thái chưa đọc
      if (deletedNoti && deletedNoti.isRead === false) {
        await db.collection("users").doc(userId).update({
          unreadCount: FieldValue.increment(-1),
        });
        logger.info(
            `Decremented unread count for user ${userId} due to deletion`,
        );
      }
    },
);
