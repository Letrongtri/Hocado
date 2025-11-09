/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Import các thư viện cần thiết
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

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
