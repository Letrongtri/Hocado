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
          dlid: statDocId,
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
* KHI CẬP NHẬT TRẠNG THÁI THÔNG BÁO (UPDATE)
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
 * KHI XÓA THÔNG BÁO (DELETE)
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

// Trigger: +1 follow cho user nếu có người follow mới được tạo
exports.incrementFollowerCount = onDocumentCreated(
    "users/{userId}/following/{followingId}",
    async (event) => {
      const userId = event.params.userId;
      const followingId = event.params.followingId;

      const userRef = db.collection("users").doc(followingId);

      try {
        await userRef.update({
          followersCount: FieldValue.increment(1),
        });
      } catch (error) {
        console
            .error(`Failed to increment follower count for ${userId}:`, error);
      }
    },
);

// Trigger: -1 follow cho user nếu có người unfollow mới được tạo
exports.decrementFollowerCount = onDocumentDeleted(
    "users/{userId}/following/{followingId}",
    async (event) => {
      const userId = event.params.userId;
      const followingId = event.params.followingId;

      const userRef = db.collection("users").doc(followingId);

      try {
        await userRef.update({
          followersCount: FieldValue.increment(-1),
        });
      } catch (error) {
        console
            .error(`Failed to decrement follower count for ${userId}:`, error);
      }
    },
);

// Trigger: +1 create deck count cho user nếu tạo deck mới
exports.incrementCreatedDecksCount = onDocumentCreated(
    "decks/{deckId}",
    async (event) => {
      const newDeck = event.data ? event.data.data() : null;
      if (!newDeck) return;

      const userId = newDeck.uid;

      const userRef = db.collection("users").doc(userId);

      try {
        await userRef.update({
          createdDecksCount: FieldValue.increment(1),
        });
      } catch (error) {
        console.error(`Failed to increment create decks count for ${userId}:`,
            error);
      }
    },
);

// Trigger: -1 create deck count cho user nếu xóa deck
exports.decrementCreatedDecksCount = onDocumentDeleted(
    "decks/{deckId}",
    async (event) => {
      const deletedDeck = event.data ? event.data.data() : null;
      if (!deletedDeck) return;

      const userId = deletedDeck.uid;

      const userRef = db.collection("users").doc(userId);

      try {
        await userRef.update({
          createdDecksCount: FieldValue.increment(-1),
        });
      } catch (error) {
        console.error(`Failed to decrement create decks count for ${userId}:`,
            error);
      }
    },
);

// Trigger: +1 save deck count cho user nếu lưu deck mới
exports.incrementSavedDecksCount = onDocumentCreated(
    "users/{userId}/saved_decks/{savedDeckId}",
    async (event) => {
      const userId = event.params.userId;

      const userRef = db.collection("users").doc(userId);

      try {
        await userRef.update({
          savedDecksCount: FieldValue.increment(1),
        });
      } catch (error) {
        console.error(`Failed to increment saved decks count for ${userId}:`,
            error);
      }
    },
);

// Trigger: -1 saved deck count cho user nếu xóa lưu deck
exports.decrementSavedDecksCount = onDocumentDeleted(
    "users/{userId}/saved_decks/{savedDeckId}",
    async (event) => {
      const userId = event.params.userId;

      const userRef = db.collection("users").doc(userId);

      try {
        await userRef.update({
          savedDecksCount: FieldValue.increment(-1),
        });
      } catch (error) {
        console.error(`Failed to decrement saved decks count for ${userId}:`,
            error);
      }
    },
);

// Gửi thông báo khi có người follow
exports.notifyOnNewFollower = onDocumentCreated(
    "users/{userId}/following/{followingId}", async (event) => {
      const userId = event.params.followingId; // người đc follow (nhận tb)
      const followerId = event.params.userId; // người follow

      try {
        // 1. Lấy thông tin chi tiết của người follow
        const followerDoc = await db.collection("users").doc(followerId).get();

        if (!followerDoc.exists) {
          logger.warn(`Follower not found: ${followerId}`);
          return;
        }

        const followerData = followerDoc.data();
        const followerName = followerData.displayName || "Một người dùng";

        // 2. Tạo thông báo vào Firestore của người được follow
        const notificationRef = db.collection("users")
            .doc(userId)
            .collection("notifications")
            .doc(); // Tự động sinh ID, chưa ghi vào DB

        await notificationRef.set({
          nid: notificationRef.id,
          uid: userId,
          title: "Người theo dõi mới! 🎉",
          message: `${followerName} đã bắt đầu theo dõi bạn.`,
          type: "social",
          metadata: {
            uid: followerId,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          createdAt: FieldValue.serverTimestamp(),
          isRead: false,
        });
        logger.info(`Notification for ${userId} about follower ${followerId}`);
      } catch (error) {
        logger.error("Error creating follow notification:", error);
      }
    });

// Gửi thông báo khi có người save deck
exports.notifyOnNewSavedDeck = onDocumentCreated(
    "users/{userId}/saved_decks/{deckId}", async (event) => {
      const data = event.data.data();
      const userId = data.uid; // người nhận tb
      const savedDeckUserId = event.params.userId; // người save

      try {
        // 1. Lấy thông tin chi tiết của người save deck
        const savedUserDoc = await db
            .collection("users")
            .doc(savedDeckUserId)
            .get();

        if (!savedUserDoc.exists) {
          logger.warn(`User not found: ${savedDeckUserId}`);
          return;
        }

        const userData = savedUserDoc.data();
        const userName = userData.displayName || "Một người dùng";

        // 2. Tạo thông báo vào Firestore của người được follow
        const notificationRef = db.collection("users")
            .doc(userId)
            .collection("notifications")
            .doc();

        await notificationRef.set({
          nid: notificationRef.id,
          uid: userId,
          title: "Người lưu thẻ mới! 🎉",
          message: `${userName} đã lưu bộ thẻ của bạn.`,
          type: "social",
          metadata: {
            uid: savedDeckUserId,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          createdAt: FieldValue.serverTimestamp(),
          isRead: false,
        });
        logger.info(`Notification for ${userId} about save deck`);
      } catch (error) {
        logger.error("Error creating save deck notification:", error);
      }
    });

// Gửi thông báo nhắc nhở học tập
exports.sendStudyReminder = onSchedule({
  schedule: "0 7 * * *",
  timeZone: "Asia/Ho_Chi_Minh",
}, async (event) => {
  const now = new Date();

  // 1. Tìm user có 'nextStudyTime' đã đến hạn (nhỏ hơn hoặc bằng hiện tại)
  const dueUsersSnapshot = await db.collection("users")
      .where("nextStudyTime", "<=", now)
      .where("fcmToken", "!=", null)
      .get();

  if (dueUsersSnapshot.empty) return;

  const messages = [];

  // 2. Tạo tin nhắn
  dueUsersSnapshot.docs.forEach((doc) => {
    const userData = doc.data();

    messages.push({
      token: userData.fcmToken,
      notification: {
        title: "Đến giờ ôn bài rồi! 🧠",
        body: "Bạn có thẻ Flashcard đã đến hạn review.",
      },
      data: {
        type: "reminder", // Để Flutter xử lý mở màn hình ôn tập
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });

  // 3. Gửi
  if (messages.length > 0) {
    await getMessaging().sendEach(messages);
    console.log(`Sent reminders to ${messages.length} users.`);
  }
});

// Trigger: +50 xp for user nếu tạo deck mới
exports.incrementXpForCreatedDecks = onDocumentCreated(
    "decks/{deckId}",
    async (event) => {
      const newDeck = event.data ? event.data.data() : null;
      if (!newDeck) return;

      const userId = newDeck.uid;

      const userRef = db.collection("users").doc(userId);

      try {
        await userRef.update({
          xp: FieldValue.increment(50),
        });
      } catch (error) {
        console.error(`Failed to increment xp for ${userId}:`,
            error);
      }
    },
);

// Trigger: +20 xp cho user nếu lưu deck mới
exports.incrementXpForSavedDecks = onDocumentCreated(
    "users/{userId}/saved_decks/{savedDeckId}",
    async (event) => {
      const userId = event.params.userId;

      const userRef = db.collection("users").doc(userId);

      try {
        await userRef.update({
          xp: FieldValue.increment(20),
        });
      } catch (error) {
        console.error(`Failed to increment xp for ${userId}:`,
            error);
      }
    },
);

// Trigger: + xp cho user nếu user học hoặc test
exports.incrementXpForSavedDecks = onDocumentCreated(
    "users/{userId}/study_sessions/{sesstionId}",
    async (event) => {
      const userId = event.params.userId;
      const data = event.data.data();
      const xp = data.correctCards;

      const userRef = db.collection("users").doc(userId);

      try {
        await userRef.update({
          xp: FieldValue.increment(xp),
        });
      } catch (error) {
        console.error(`Failed to increment xp for ${userId}:`,
            error);
      }
    },
);
