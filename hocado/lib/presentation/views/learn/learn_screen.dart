import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/learn_provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/learning_settings.dart';
import 'package:hocado/data/models/question.dart';
import 'package:hocado/data/models/study_session.dart';
import 'package:hocado/data/models/user_answer.dart';
import 'package:hocado/presentation/viewmodels/learn/learn_view_model.dart';
import 'package:hocado/presentation/views/learn/flashcard_answer.dart';
import 'package:hocado/presentation/views/learn/learn_flashcard_header.dart';
import 'package:hocado/presentation/views/learn/learn_question_prompt.dart';
import 'package:hocado/presentation/views/learn/learning_overview.dart';
import 'package:hocado/presentation/views/learn/multiple_choice_answer.dart';
import 'package:hocado/presentation/views/learn/written_answer.dart';

class LearnScreen extends ConsumerStatefulWidget {
  final String did;
  final LearningSettings settings;

  const LearnScreen({super.key, required this.did, required this.settings});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  bool isAnswered = false;
  bool isShowAnswerForFlashcard = false;
  UserAnswer? userAnswer;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      learnViewModelProvider((widget.did, widget.settings)),
    );
    final notifier = ref.watch(
      learnViewModelProvider((widget.did, widget.settings)).notifier,
    );

    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final learn = state.value!;
    final progress = learn.currentIndex + 1;
    final total = learn.questions.length;
    final question = learn.currentQuestion;
    final questionType = question?.type ?? QuestionTypes.flashcard.name;

    final theme = Theme.of(context);

    if (question == null) {
      _controllerCenter.play();
      return _buildCongraScreen(theme, learn.session);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildCustomAppBar(context, progress, total),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.pushNamed(
                AppRoutes.learningSettings.name,
                pathParameters: {'did': widget.did},
              );
            },
          ),
          SizedBox(width: Sizes.sm),
        ],
        titleSpacing: 0,
        toolbarHeight: 60,
      ),
      body: _buildMainLearningSession(
        theme,
        context,
        question,
        questionType,
        notifier,
        false,
      ),
      bottomNavigationBar: isAnswered
          ? _buildNextButton(context, theme, notifier)
          : null,
    );
  }

  Widget _buildCongraScreen(ThemeData theme, StudySession session) {
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Hiệu ứng pháo giấy
          ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            emissionFrequency: 0.04,
            numberOfParticles: 8,
            maxBlastForce: 15,
            minBlastForce: 5,
            gravity: 0.1,
            colors: const [
              Colors.pink,
              Colors.orange,
              Colors.yellow,
              Colors.purple,
              Colors.blue,
              Colors.white,
            ],
          ),

          // Nội dung chính
          SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Sizes.lg),
                      Text(
                        "Congratulation",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 36,
                        ),
                      ),
                      SizedBox(height: Sizes.md),
                      Text(
                        "Bạn đang làm rất tốt, hãy tiếp tục!",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      SizedBox(height: Sizes.lg),
                      LearningOverview(session),
                      SizedBox(height: Sizes.xl),

                      Container(
                        width: double.infinity,
                        height: Sizes.btnHeight,
                        margin: EdgeInsets.only(bottom: Sizes.lg),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Sizes.btnLgRadius,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            ref.invalidate(learnViewModelProvider);
                          },
                          child: const Text(
                            'Tiếp tục',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(Sizes.sm),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Main learning session
  Widget _buildMainLearningSession(
    ThemeData theme,
    BuildContext context,
    Question question,
    String questionType,
    LearnViewModel notifier,
    bool isStarred,
  ) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        margin: EdgeInsets.all(Sizes.md),
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          children: [
            // Flashcard header
            LearnFlashcardHeader(
              hint: question.hint,
              isStarred: isStarred,
              onStarred: (isStarred) {
                // notifier.updateFlashCardProgress(question.fid, isStarred);
              },
            ),
            const SizedBox(height: Sizes.lg),

            // Question prompt
            Flexible(
              child: LearnQuestionPrompt(
                question: question,
                questionFormat: widget.settings.questionFormat,
                isShowAnswer: isShowAnswerForFlashcard,
              ),
            ),

            // Answer options
            const SizedBox(height: Sizes.lg),
            if (questionType == QuestionTypes.flashcard.name)
              FlashcardAnswer(
                onAnswered: (remembered) {
                  var answer = notifier.createAnswer(
                    question: question,
                    userResponse: remembered ? question.answer : '',
                  );
                  answer = answer.copyWith(isCorrect: remembered);

                  setState(() {
                    userAnswer = answer;
                    isAnswered = true;
                  });
                },
                onShowAnswer: (showAnswer) {
                  setState(() {
                    isShowAnswerForFlashcard = showAnswer;
                  });
                },
                answer: userAnswer,
              ),
            if (questionType == QuestionTypes.multipleChoice.name ||
                questionType == QuestionTypes.trueFalse.name)
              MultipleChoiceAnswer(
                question: question,
                answer: userAnswer,
                onAnswered: (response) {
                  final answer = notifier.createAnswer(
                    question: question,
                    userResponse: response,
                  );

                  setState(() {
                    userAnswer = answer;
                    isAnswered = true;
                  });
                },
              ),
            if (questionType == QuestionTypes.written.name)
              WrittenAnswer(
                onAnswered: (response) {
                  final answer = notifier.createAnswer(
                    question: question,
                    userResponse: response,
                  );
                  setState(() {
                    userAnswer = answer;
                    isAnswered = true;
                  });
                },
                answer: userAnswer,
              ),
          ],
        ),
      ),
    );
  }

  // --- Widget AppBar tùy chỉnh ---
  Widget _buildCustomAppBar(BuildContext context, int progress, int total) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: Sizes.md),
            child: LinearProgressIndicator(
              value: progress / total,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
            ),
          ),
        ),
        Text(
          '$progress / $total',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    ThemeData theme,
    LearnViewModel notifier,
  ) {
    return Container(
      width: double.infinity,
      height: Sizes.btnLgHeight,
      padding: const EdgeInsets.all(Sizes.md),
      color: theme.colorScheme.secondary,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Sizes.btnLgRadius,
            ),
          ),
        ),
        onPressed: () async {
          await notifier.nextQuestion(userAnswer!);

          setState(() {
            userAnswer = null;
            isAnswered = false;
            isShowAnswerForFlashcard = false;
          });
        },
        child: const Text(
          'Tiếp theo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
