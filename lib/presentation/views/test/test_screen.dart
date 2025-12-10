import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/test/submit_test_button.dart';
import 'package:hocado/presentation/views/test/test_question_item.dart';
import 'package:hocado/presentation/views/test/test_result_header.dart';

class TestScreen extends ConsumerWidget {
  final String did;
  final LearningSettings settings;

  const TestScreen({super.key, required this.did, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(testViewModelProvider((did, settings)));

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            _onClosePressed(context, asyncState.value?.isSubmitted ?? false);
          },
        ),
        title: Text('Kiểm tra', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.pushNamed(
                AppRoutes.learningSettings.name,
                pathParameters: {'did': did},
                queryParameters: {'mode': 'test'},
              );
            },
          ),
          SizedBox(width: Sizes.sm),
        ],
        titleSpacing: 0,
        toolbarHeight: 60,
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Lỗi: $err")),
        data: (state) {
          return Column(
            children: [
              if (state.isSubmitted)
                TestResultHeader(
                  correct: state.correctCount ?? 0,
                  total: state.totalCount ?? 0,
                ),

              // 2. Danh sách câu hỏi (Scrollable)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(Sizes.md),
                  itemCount: state.questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: Sizes.sm),
                  itemBuilder: (context, index) {
                    final question = state.questions[index];

                    // Lấy câu trả lời user đã chọn (nếu có)
                    final userRes = state.userResponses[question.qid];

                    // Lấy kết quả chấm (chỉ có khi isSubmitted = true)
                    // Tìm trong list results xem câu này đúng hay sai
                    final result = state.isSubmitted
                        ? state.userResults?.firstWhere(
                            (r) => r.qid == question.qid,
                          )
                        : null;

                    final notifier = ref.read(
                      testViewModelProvider((did, settings)).notifier,
                    );

                    return TestQuestionItem(
                      index: index + 1,
                      question: question,
                      userResponse: userRes,
                      result: result,
                      isSubmitted: state.isSubmitted,
                      // Truyền callback thay vì truyền notifier
                      onAnswerChanged: (val) {
                        notifier.updateAnswer(question.qid, val);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: asyncState.hasValue && !asyncState.value!.isSubmitted
          ? SubmitTestButton(
              notifier: ref.read(
                testViewModelProvider((did, settings)).notifier,
              ),
            )
          : null,
    );
  }

  void _onClosePressed(BuildContext context, bool isSubmitted) {
    final theme = Theme.of(context);
    if (isSubmitted) {
      context.pop();
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Thoát bài kiểm tra?"),
          content: const Text("Tiến độ làm bài của bạn sẽ không được lưu."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.pop(); // Thoát màn hình
              },
              child: Text(
                "Thoát",
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Tiếp tục"),
            ),
          ],
        ),
      );
    }
  }
}
