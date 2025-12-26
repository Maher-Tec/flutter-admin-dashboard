import 'package:flutter/material.dart';
import 'package:admin_dash/l10n/app_localizations.dart';
import '../../core/constants/constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/chart_widgets.dart';

/// Analytics screen with detailed charts
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final crossAxisCount = context.gridCrossAxisCount;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(isDark: isDark),
          SizedBox(height: AppConstants.paddingLG),
          _SummaryCards(crossAxisCount: crossAxisCount),
          SizedBox(height: AppConstants.paddingLG),
          TrendLineChart(
            title: 'Monthly Revenue',
            data: MockData.monthlyRevenue,
            lineColor: AppColors.success,
          ),
          SizedBox(height: AppConstants.paddingMD),
          _ChartsSection(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.analytics,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Track your business performance',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: 'Last 30 Days',
              items: ['Last 7 Days', 'Last 30 Days', 'Last 90 Days']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.crossAxisCount});
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppConstants.paddingMD,
      mainAxisSpacing: AppConstants.paddingMD,
      childAspectRatio: context.responsive(mobile: 1.8, tablet: 1.6, desktop: 2.2),
      children: [
        StatCard(
          title: AppLocalizations.of(context)!.totalRevenue,
          value: '\$343K',
          icon: Icons.attach_money_rounded,
          iconColor: AppColors.success,
          change: 24.5,
          isPositiveChange: true,
        ),
        StatCard(
          title: AppLocalizations.of(context)!.activeSessions,
          value: '\$247',
          icon: Icons.shopping_cart_rounded,
          iconColor: AppColors.primary,
          change: 8.2,
          isPositiveChange: true,
        ),
        StatCard(
          title: AppLocalizations.of(context)!.conversionRate,
          value: '3.2%',
          icon: Icons.sync_alt_rounded,
          iconColor: AppColors.info,
          change: 0.5,
          isPositiveChange: true,
        ),
        StatCard(
          title: AppLocalizations.of(context)!.totalUsers,
          value: '68%',
          icon: Icons.people_rounded,
          iconColor: AppColors.accent,
          change: -2.1,
          isPositiveChange: false,
        ),
      ],
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection();

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? Column(
            children: [
              TrendLineChart(title: 'Weekly Trend', data: MockData.weeklyGrowth),
              SizedBox(height: AppConstants.paddingMD),
              ActivityBarChart(
                title: 'Daily Users',
                data: MockData.dailyActivity,
                barColor: AppColors.info,
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: TrendLineChart(title: 'Weekly Trend', data: MockData.weeklyGrowth)),
              SizedBox(width: AppConstants.paddingMD),
              Expanded(
                child: ActivityBarChart(
                  title: 'Daily Users',
                  data: MockData.dailyActivity,
                  barColor: AppColors.info,
                ),
              ),
            ],
          );
  }
}
