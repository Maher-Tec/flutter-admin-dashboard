import 'package:flutter/material.dart';
import 'package:admin_dash/l10n/app_localizations.dart';
import '../../core/constants/constants.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/chart_widgets.dart';
import '../../widgets/tables/activity_table.dart';

/// Dashboard home screen with premium animations
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkBackground,
                    AppColors.darkBackground,
                    AppColors.primary.withValues(alpha: 0.03),
                  ]
                : [
                    AppColors.lightBackground,
                    AppColors.lightBackground,
                    AppColors.primary.withValues(alpha: 0.02),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header with animation
              _WelcomeHeader(),

              SizedBox(height: AppConstants.paddingLG),

              // KPI Cards Grid with staggered animation
              GridView.extent(
                maxCrossAxisExtent: 350,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppConstants.paddingMD,
                mainAxisSpacing: AppConstants.paddingMD,
                childAspectRatio: context.responsive(
                  mobile: 0.95, // Even taller for mobile
                  tablet: 1.2,
                  desktop: 1.4, // Taller for desktop (was 1.6)
                ),
                children: [
                  StatCard(
                    title: AppLocalizations.of(context)!.totalUsers,
                    value: _formatNumber(MockData.totalUsers),
                    icon: Icons.people_rounded,
                    iconColor: AppColors.primary,
                    accentColor: AppColors.cardAccentBlue,
                    change: MockData.usersChange,
                    isPositiveChange: MockData.usersChange >= 0,
                    animationDelay: const Duration(milliseconds: 0),
                  ),
                  StatCard(
                    title: AppLocalizations.of(context)!.activeSessions,
                    value: MockData.activeOrders.toString(),
                    icon: Icons.shopping_bag_rounded,
                    iconColor: AppColors.accent,
                    accentColor: AppColors.cardAccentPurple,
                    change: MockData.ordersChange,
                    isPositiveChange: MockData.ordersChange >= 0,
                    animationDelay: const Duration(milliseconds: 100),
                  ),
                  StatCard(
                    title: AppLocalizations.of(context)!.totalRevenue,
                    value: '\$${_formatNumber(MockData.revenue.toInt())}',
                    icon: Icons.attach_money_rounded,
                    iconColor: AppColors.success,
                    accentColor: AppColors.cardAccentGreen,
                    change: MockData.revenueChange,
                    isPositiveChange: MockData.revenueChange >= 0,
                    animationDelay: const Duration(milliseconds: 200),
                  ),
                  StatCard(
                    title: AppLocalizations.of(context)!.conversionRate,
                    value: '${MockData.growthPercentage}%',
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColors.info,
                    accentColor: AppColors.cardAccentOrange,
                    change: MockData.growthPercentage,
                    isPositiveChange: true,
                    animationDelay: const Duration(milliseconds: 300),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.paddingLG),

              // Charts Section with fade-in
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: context.isMobile
                    ? Column(
                        children: [
                          TrendLineChart(
                            title: AppLocalizations.of(context)!.weeklyRevenue,
                            data: MockData.weeklyGrowth,
                          ),
                          SizedBox(height: AppConstants.paddingMD),
                          ActivityBarChart(
                            title: AppLocalizations.of(context)!.dailyActivity,
                            data: MockData.dailyActivity,
                            barColor: AppColors.accent,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TrendLineChart(
                              title: AppLocalizations.of(context)!.weeklyRevenue,
                              data: MockData.weeklyGrowth,
                            ),
                          ),
                          SizedBox(width: AppConstants.paddingMD),
                          Expanded(
                            flex: 2,
                            child: ActivityBarChart(
                              title: AppLocalizations.of(context)!.dailyActivity,
                              data: MockData.dailyActivity,
                              barColor: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
              ),

              SizedBox(height: AppConstants.paddingLG),

              // Activity Table with animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: ActivityTable(
                  title: AppLocalizations.of(context)!.recentActivity,
                  activities: MockData.activities,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }
}

/// Welcome header widget with gradient text
class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;

    final l10n = AppLocalizations.of(context)!;
    if (hour < 12) {
      greeting = l10n.goodMorning;
      greetingIcon = Icons.wb_sunny_rounded;
    } else if (hour < 17) {
      greeting = l10n.goodAfternoon;
      greetingIcon = Icons.wb_sunny_outlined;
    } else {
      greeting = l10n.goodEvening;
      greetingIcon = Icons.nightlight_round;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Animated gradient icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        greetingIcon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          AppColors.primary,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        l10n.welcomeAdmin(greeting, l10n.admin),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.welcomeSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
