import 'package:flutter/material.dart';
import 'package:hocado/core/constants/colors.dart';
import 'package:hocado/core/constants/sizes.dart';

class TestResultHeader extends StatelessWidget {
  const TestResultHeader({
    super.key,
    required this.correct,
    required this.total,
  });

  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = total > 0 ? (correct / total * 10).toStringAsFixed(1) : "0";

    return Container(
      width: double.infinity,
      color: correct >= (total / 2)
          ? AppColors.correctColorFg
          : AppColors.incorrectColorFg,
      padding: const EdgeInsets.all(Sizes.md),
      child: Column(
        children: [
          Text(
            "Kết quả: $correct / $total câu đúng",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Điểm số: $score / 10",
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
