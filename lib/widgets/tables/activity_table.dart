import 'package:flutter/material.dart';
import 'package:admin_dash/l10n/app_localizations.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/activity_model.dart';

/// Activity table widget with premium effects
class ActivityTable extends StatelessWidget {
  const ActivityTable({
    super.key,
    required this.activities,
    this.title,
    this.showPagination = true,
  });

  final List<ActivityModel> activities;
  final String? title;
  final bool showPagination;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider.withValues(alpha: 0.5)
              : AppColors.lightDivider.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingLG),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.history_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title ?? AppLocalizations.of(context)!.recentActivity,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  _FilterButton(isDark: isDark),
                ],
              ),
            ),
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLG,
              vertical: AppConstants.paddingMD,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground.withValues(alpha: 0.5)
                  : AppColors.lightBackground,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
                bottom: BorderSide(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
              ),
            ),
            child: Row(
              children: [
                _TableHeader(l10n.id, flex: 1, isDark: isDark),
                _TableHeader(l10n.user, flex: 2, isDark: isDark),
                _TableHeader(l10n.activity, flex: 3, isDark: isDark),
                _TableHeader(l10n.status, flex: 1, isDark: isDark),
                _TableHeader(l10n.date, flex: 2, isDark: isDark),
              ],
            ),
          ),
          // Table Body with staggered animation
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
            itemBuilder: (context, index) {
              return _ActivityTableRow(
                activity: activities[index],
                isDark: isDark,
                animationDelay: Duration(milliseconds: index * 50),
              );
            },
          ),
          // Pagination
          if (showPagination)
            _TablePagination(
              isDark: isDark,
              total: activities.length,
            ),
        ],
      ),
    );
  }
}

/// Filter button with hover effect
class _FilterButton extends StatefulWidget {
  const _FilterButton({required this.isDark});

  final bool isDark;

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton.icon(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: _isHovered ? AppColors.primary : null,
          ),
          icon: Icon(Icons.filter_list_rounded, size: 18),
          label: Text(AppLocalizations.of(context)!.filter),
        ),
      ),
    );
  }
}

/// Table header cell
class _TableHeader extends StatelessWidget {
  const _TableHeader(
    this.text, {
    required this.flex,
    required this.isDark,
  });

  final String text;
  final int flex;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color:
              isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

/// Activity table row with hover and entrance animation
class _ActivityTableRow extends StatefulWidget {
  const _ActivityTableRow({
    required this.activity,
    required this.isDark,
    this.animationDelay = Duration.zero,
  });

  final ActivityModel activity;
  final bool isDark;
  final Duration animationDelay;

  @override
  State<_ActivityTableRow> createState() => _ActivityTableRowState();
}

class _ActivityTableRowState extends State<_ActivityTableRow>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: AppConstants.animationFast,
            color: _isHovered
                ? (widget.isDark
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : AppColors.primary.withValues(alpha: 0.03))
                : Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLG,
              vertical: AppConstants.paddingMD,
            ),
            child: Row(
              children: [
                // ID with monospace style
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? AppColors.darkBackground.withValues(alpha: 0.5)
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.activity.id,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ),
                // User
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: ClipOval(
                            child: Image.network(
                              widget.activity.userAvatar,
                              errorBuilder: (context, error, stackTrace) => Text(
                                widget.activity.userName[0],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppConstants.paddingSM),
                      Expanded(
                        child: Text(
                          widget.activity.userName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: widget.isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.activity.action,
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Status
                Expanded(
                  flex: 1,
                  child: _StatusBadge(status: widget.activity.status),
                ),
                // Date
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: widget.isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _formatDate(context, widget.activity.timestamp),
                          style: TextStyle(
                            fontSize: 13,
                            color: widget.isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    final l10n = AppLocalizations.of(context)!;

    if (diff.inMinutes < 60) {
      return l10n.minutesAgo(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return l10n.hoursAgo(diff.inHours);
    } else if (diff.inDays < 7) {
      return l10n.daysAgo(diff.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Status badge widget with gradient
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ActivityStatus status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case ActivityStatus.success:
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;
      case ActivityStatus.pending:
        bgColor = AppColors.warningLight;
        textColor = AppColors.warning;
        icon = Icons.schedule_rounded;
        break;
      case ActivityStatus.failed:
        bgColor = AppColors.errorLight;
        textColor = AppColors.error;
        icon = Icons.cancel_rounded;
        break;
      case ActivityStatus.warning:
        bgColor = AppColors.warningLight;
        textColor = AppColors.warning;
        icon = Icons.warning_rounded;
        break;
    }

    final isMobile = MediaQuery.sizeOf(context).width < AppConstants.mobileBreakpoint;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : AppConstants.paddingSM,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              status.label,
              style: TextStyle(
                fontSize: isMobile ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Table pagination with hover effects
class _TablePagination extends StatefulWidget {
  const _TablePagination({
    required this.isDark,
    required this.total,
  });

  final bool isDark;
  final int total;

  @override
  State<_TablePagination> createState() => _TablePaginationState();
}

class _TablePaginationState extends State<_TablePagination> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMD),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: widget.isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.showingResults(1, widget.total, widget.total),
            style: TextStyle(
              fontSize: 13,
              color: widget.isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Row(
            children: [
              _PaginationButton(
                icon: Icons.chevron_left_rounded,
                isEnabled: _currentPage > 1,
                isDark: widget.isDark,
                onPressed: () {
                  if (_currentPage > 1) {
                    setState(() => _currentPage--);
                  }
                },
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMD,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$_currentPage',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _PaginationButton(
                icon: Icons.chevron_right_rounded,
                isEnabled: false,
                isDark: widget.isDark,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pagination button
class _PaginationButton extends StatefulWidget {
  const _PaginationButton({
    required this.icon,
    required this.isEnabled,
    required this.isDark,
    required this.onPressed,
  });

  final IconData icon;
  final bool isEnabled;
  final bool isDark;
  final VoidCallback onPressed;

  @override
  State<_PaginationButton> createState() => _PaginationButtonState();
}

class _PaginationButtonState extends State<_PaginationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        decoration: BoxDecoration(
          color: _isHovered && widget.isEnabled
              ? AppColors.primary.withValues(alpha: 0.1)
              : (widget.isDark
                  ? AppColors.darkBackground.withValues(alpha: 0.5)
                  : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: widget.isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
        child: IconButton(
          onPressed: widget.isEnabled ? widget.onPressed : null,
          icon: Icon(widget.icon),
          iconSize: 20,
          color: widget.isEnabled
              ? (_isHovered ? AppColors.primary : null)
              : (widget.isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary),
        ),
      ),
    );
  }
}
