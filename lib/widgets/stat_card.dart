import 'package:flutter/material.dart';
import 'package:admin_dash/l10n/app_localizations.dart';
import '../core/constants/constants.dart';
import '../core/theme/app_colors.dart';

/// Statistic card widget for KPIs with premium effects
class StatCard extends StatefulWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.change,
    this.isPositiveChange = true,
    this.subtitle,
    this.accentColor,
    this.animationDelay = Duration.zero,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final double? change;
  final bool isPositiveChange;
  final String? subtitle;
  final Color? accentColor;
  final Duration animationDelay;

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    // Delayed entrance animation
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor = widget.iconColor ?? AppColors.primary;
    final effectiveAccentColor = widget.accentColor ?? (widget.change == null ? effectiveIconColor : (widget.isPositiveChange ? AppColors.success : AppColors.error));
    final effectiveIconBgColor = widget.iconBackgroundColor ?? effectiveIconColor.withValues(alpha: isDark ? 0.2 : 0.1);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: child,
            ),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            border: Border.all(
              color: _isHovered 
                  ? effectiveAccentColor.withValues(alpha: 0.3)
                  : (isDark ? AppColors.darkDivider.withValues(alpha: 0.5) : AppColors.lightDivider.withValues(alpha: 0.5)),
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? effectiveAccentColor.withValues(alpha: 0.15)
                    : (isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04)),
                blurRadius: _isHovered ? 20 : 8,
                offset: Offset(0, _isHovered ? 8 : 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Gradient accent line at top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: AppConstants.animationFast,
                  height: _isHovered ? 3 : 0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        effectiveAccentColor,
                        effectiveAccentColor.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.sizeOf(context).width < 380
                      ? AppConstants.paddingSM
                      : MediaQuery.sizeOf(context).width < 450
                          ? AppConstants.paddingMD
                          : AppConstants.paddingLG,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        AnimatedContainer(
                          duration: AppConstants.animationFast,
                          padding: EdgeInsets.all(AppConstants.paddingSM),
                          decoration: BoxDecoration(
                            color: effectiveIconBgColor,
                            borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                            boxShadow: _isHovered
                                ? [
                                    BoxShadow(
                                      color: effectiveIconColor.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            widget.icon,
                            size: 18,
                            color: effectiveIconColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final screenWidth = MediaQuery.sizeOf(context).width;
                        return Opacity(
                          opacity: value,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.value,
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 22 : 28,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    if (widget.change != null || widget.subtitle != null)
                      Row(
                        children: [
                          if (widget.change != null) ...[
                            AnimatedContainer(
                              duration: AppConstants.animationFast,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.isPositiveChange
                                      ? [
                                          AppColors.successLight,
                                          AppColors.successLight.withValues(alpha: 0.7),
                                        ]
                                      : [
                                          AppColors.errorLight,
                                          AppColors.errorLight.withValues(alpha: 0.7),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.isPositiveChange
                                        ? Icons.trending_up_rounded
                                        : Icons.trending_down_rounded,
                                    size: 14,
                                    color: widget.isPositiveChange
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${widget.change!.abs().toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: widget.isPositiveChange
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              widget.subtitle ?? AppLocalizations.of(context)!.vsLastMonth,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
