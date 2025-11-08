import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/viewmodels/viewmodels.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:hocado/presentation/widgets/hocado_switch.dart';

class LearningSettingsScreen extends ConsumerWidget {
  final String did;

  const LearningSettingsScreen({super.key, required this.did});

  LearningSettings _updateQuestionType(
    bool value,
    LearningSettings settings,
    String valueString,
  ) {
    // Tạo bản sao
    final questionTypes = List<String>.from(settings.questionTypes);

    if (value) {
      // Nếu người dùng bật switch
      if (!questionTypes.contains(valueString)) {
        questionTypes.add(valueString);
      }
    } else {
      // Nếu người dùng tắt switch
      questionTypes.remove(valueString);
    }

    // Trả về settings mới với danh sách câu hỏi đã cập nhật
    return settings.copyWith(
      questionTypes: questionTypes,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(learningSettingsViewModelProvider(did));
    final notifier = ref.watch(learningSettingsViewModelProvider(did).notifier);

    final settings = state.value;

    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: HocadoBack(),
        title: Text(
          'Cài đặt',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.md,
                vertical: Sizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Types
                  _buildSectionTitle(context, 'Loại câu hỏi', theme),
                  _buildToggleOption(
                    ref,
                    'Flashcards',
                    theme,
                    settings.questionTypes.contains(
                      QuestionTypes.flashcard.name,
                    ),
                    (value) {
                      final newSettings = _updateQuestionType(
                        value,
                        settings,
                        QuestionTypes.flashcard.name,
                      );

                      // Gọi notifier để cập nhật state
                      notifier.updateSettings(newSettings);
                    },
                  ),
                  _buildToggleOption(
                    ref,
                    'Nhiều lựa chọn',
                    theme,
                    settings.questionTypes.contains(
                      QuestionTypes.multipleChoice.name,
                    ),
                    (value) {
                      final newSettings = _updateQuestionType(
                        value,
                        settings,
                        QuestionTypes.multipleChoice.name,
                      );

                      // Gọi notifier để cập nhật state
                      notifier.updateSettings(newSettings);
                    },
                  ),
                  _buildToggleOption(
                    ref,
                    'Viết',
                    theme,
                    settings.questionTypes.contains(
                      QuestionTypes.written.name,
                    ),
                    (value) {
                      final newSettings = _updateQuestionType(
                        value,
                        settings,
                        QuestionTypes.written.name,
                      );

                      // Gọi notifier để cập nhật state
                      notifier.updateSettings(newSettings);
                    },
                  ),
                  _buildToggleOption(
                    ref,
                    'Đúng sai',
                    theme,
                    settings.questionTypes.contains(
                      QuestionTypes.trueFalse.name,
                    ),
                    (value) {
                      final newSettings = _updateQuestionType(
                        value,
                        settings,
                        QuestionTypes.trueFalse.name,
                      );

                      // Gọi notifier để cập nhật state
                      notifier.updateSettings(newSettings);
                    },
                  ),
                  const SizedBox(height: Sizes.md),

                  // Question Format
                  _buildSectionTitle(context, 'Dạng câu hỏi', theme),
                  _buildToggleOption(
                    ref,
                    'Trả lời bằng thuật ngữ',
                    theme,
                    settings.questionFormat ==
                        QuestionFormat
                            .answerWithTerm
                            .name, // chỉ bật nếu đang ở chế độ 'term'
                    (value) {
                      if (value) {
                        // Bật chế độ "thuật ngữ" → tắt "định nghĩa"
                        final newSettings = settings.copyWith(
                          questionFormat: QuestionFormat.answerWithTerm.name,
                        );
                        notifier.updateSettings(newSettings);
                      } else {
                        // Nếu người dùng tắt thuật ngữ, tự động bật định nghĩa
                        final newSettings = settings.copyWith(
                          questionFormat:
                              QuestionFormat.answerWithDefinition.name,
                        );
                        notifier.updateSettings(newSettings);
                      }
                    },
                  ),
                  _buildToggleOption(
                    ref,
                    'Trả lời bằng định nghĩa',
                    theme,
                    settings.questionFormat ==
                        QuestionFormat
                            .answerWithDefinition
                            .name, // chỉ bật nếu đang ở chế độ 'definition'
                    (value) {
                      if (value) {
                        // Bật chế độ "định nghĩa" → tắt "thuật ngữ"
                        final newSettings = settings.copyWith(
                          questionFormat:
                              QuestionFormat.answerWithDefinition.name,
                        );
                        notifier.updateSettings(newSettings);
                      } else {
                        // Nếu người dùng tắt định nghĩa, tự động bật thuật ngữ
                        final newSettings = settings.copyWith(
                          questionFormat: QuestionFormat.answerWithTerm.name,
                        );
                        notifier.updateSettings(newSettings);
                      }
                    },
                  ),
                  const SizedBox(height: Sizes.md),

                  // Learning Options
                  _buildSectionTitle(context, 'Tùy chọn học tập', theme),
                  _buildLengthOfRounds(ref, theme, settings, notifier),
                  _buildToggleOption(
                    ref,
                    'Chỉ học cụm từ có dấu sao',
                    theme,
                    settings.studyStarredOnly,
                    (value) {
                      final newSettings = settings.copyWith(
                        studyStarredOnly: value,
                      );
                      notifier.updateSettings(newSettings);
                    },
                  ),
                  _buildToggleOption(
                    ref,
                    'Trộn thẻ',
                    theme,
                    settings.shuffle,
                    (value) {
                      final newSettings = settings.copyWith(
                        shuffle: value,
                      );
                      notifier.updateSettings(newSettings);
                    },
                  ),
                  const SizedBox(height: Sizes.xl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildStartButton(
        context,
        theme,
        settings,
        notifier,
      ),
    );
  }

  // --- Các Widget con để tái sử dụng ---

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.sm, top: Sizes.sm),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildLengthOfRounds(
    WidgetRef ref,
    ThemeData theme,
    LearningSettings settings,
    LearningSettingsViewModel notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Số vòng', style: theme.textTheme.bodyLarge),
          SizedBox(
            width: 70,
            height: 40,
            child: TextFormField(
              initialValue: settings.defaultRounds.toString(),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final int? parsed = int.tryParse(value);
                if (parsed != null && parsed > 0) {
                  final newSettings = settings.copyWith(defaultRounds: parsed);
                  notifier.updateSettings(newSettings);
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(Sizes.xs),
                filled: true,
                fillColor: Colors.white.withAlpha(40),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  borderSide: BorderSide(
                    color: theme.colorScheme.onPrimary.withAlpha(100),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  borderSide: BorderSide(
                    color: theme.colorScheme.onPrimary,
                    width: 1.6,
                  ),
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    WidgetRef ref,
    String title,
    ThemeData theme,
    bool initialValue,
    Function(bool) onChanged,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.bodyLarge),
            HocadoSwitch(initialValue: initialValue, onChanged: onChanged),
          ],
        ),
        SizedBox(height: Sizes.xs),
      ],
    );
  }

  Widget _buildStartButton(
    BuildContext context,
    ThemeData theme,
    LearningSettings settings,
    LearningSettingsViewModel notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(Sizes.md),
      height: Sizes.btnLgHeight,
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
          await notifier.saveDeckSettings();

          if (!context.mounted) return; // tránh lỗi khi widget bị dispose

          context.pushReplacementNamed(
            AppRoutes.learnDeck.name,
            pathParameters: {'did': did},
            extra: settings,
          );
        },
        child: const Text(
          'Bắt đầu học',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
