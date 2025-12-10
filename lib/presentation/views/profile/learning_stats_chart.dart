import 'package:flutter/material.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/models.dart';
import 'package:intl/intl.dart';
import 'package:material_charts/material_charts.dart';

class LearningStatsChart extends StatelessWidget {
  final List<DailyLearningStat> stats;

  const LearningStatsChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Đảm bảo dữ liệu được sắp xếp theo ngày
    stats.sort((a, b) => a.date.compareTo(b.date));

    // Giới hạn trong 7 ngày gần nhất (nếu cần)
    final recentStats = stats.length > 7
        ? stats.sublist(stats.length - 7)
        : stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(Sizes.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hiệu quả học tập (7 ngày qua)",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: Sizes.sm),
              Padding(
                padding: const EdgeInsets.only(
                  right: Sizes.md,
                  top: Sizes.md,
                ),
                child: _buildEfficiencyChart(context, recentStats),
              ),
            ],
          ),
        ),

        SizedBox(height: Sizes.md),

        Container(
          padding: EdgeInsets.all(Sizes.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thời gian học (7 ngày qua/phút)",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: Sizes.sm),
              Padding(
                padding: const EdgeInsets.all(Sizes.sm),
                child: _buildStudyTimeChart(context, recentStats),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEfficiencyChart(
    BuildContext context,
    List<DailyLearningStat> stats,
  ) {
    final theme = Theme.of(context);
    final totalCorrect = stats.fold<int>(0, (sum, e) => sum + e.totalCorrect);
    final totalIncorrect = stats.fold<int>(
      0,
      (sum, e) => sum + e.totalIncorrect,
    );
    final total = totalCorrect + totalIncorrect;
    final accuracy = total == 0 ? 0 : (totalCorrect / total * 100);

    return MaterialChartHollowSemiCircle(
      percentage: double.tryParse('$accuracy') ?? 0.0,
      size: 280,
      hollowRadius: 0.65,
      style: ChartStyle(
        activeColor: theme.colorScheme.primary,
        inactiveColor: Colors.grey[300]!,
        showPercentageText: true,
        showLegend: true,
        percentageStyle: theme.textTheme.displayLarge,
        legendStyle: theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildStudyTimeChart(
    BuildContext context,
    List<DailyLearningStat> stats,
  ) {
    final theme = Theme.of(context); // Lấy theme hiện tại

    // Chuyển đổi List<DailyLearningStat> sang List<AreaChartData>
    final List<AreaChartData> dataPoints = stats.map((stat) {
      return AreaChartData(
        value: stat.totalMinutesStudied.toDouble(), // Giá trị (trục Y)
        label: DateFormat('d/M').format(stat.date), // Nhãn (trục X)
      );
    }).toList();

    final List<AreaChartSeries> seriesList = [
      AreaChartSeries(
        name: 'Thời gian học',
        dataPoints: dataPoints,
        color: theme.colorScheme.primary,
        gradientColor: theme.colorScheme.primary.withAlpha(50),
        lineWidth: Sizes.xs,
        pointSize: Sizes.sm,
      ),
    ];

    return MaterialAreaChart(
      series: seriesList,
      width: double.infinity,
      height: 280,
      style: AreaChartStyle(
        gridColor: Colors.grey.withAlpha(100), // Màu lưới
        labelStyle: theme.textTheme.bodySmall,
        showPoints: true,
        animationDuration: const Duration(milliseconds: 1500),
        animationCurve: Curves.easeOut,
        showGrid: true,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.lg,
          vertical: Sizes.md,
        ),
      ),
    );
  }
}
