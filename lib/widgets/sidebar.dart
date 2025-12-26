import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_dash/l10n/app_localizations.dart';
import '../core/constants/constants.dart';
import '../core/theme/app_colors.dart';
import '../core/providers/navigation_provider.dart';
import '../core/providers/theme_provider.dart';

/// Collapsible sidebar navigation widget with premium effects
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final isCollapsed = navProvider.isSidebarCollapsed;

    return AnimatedContainer(
      duration: AppConstants.animationNormal,
      curve: Curves.easeInOut,
      width: isCollapsed
          ? AppConstants.sidebarCollapsedWidth
          : AppConstants.sidebarExpandedWidth,
      decoration: BoxDecoration(
        color: isDark ? AppColors.sidebarDark : AppColors.sidebarLight,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo & Brand with gradient
          _SidebarHeader(isCollapsed: isCollapsed, isDark: isDark),

          const Divider(height: 1),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: AppConstants.paddingMD,
                horizontal: AppConstants.paddingSM,
              ),
              children: NavItem.values.asMap().entries.map((entry) {
                return _SidebarNavItem(
                  item: entry.value,
                  isActive: navProvider.currentItem == entry.value,
                  isCollapsed: isCollapsed,
                  isDark: isDark,
                  onTap: () => navProvider.navigateTo(entry.value),
                  animationDelay: Duration(milliseconds: entry.key * 50),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Powered by AmoMaherTec footer
          _PoweredByFooter(isCollapsed: isCollapsed, isDark: isDark),

          const Divider(height: 1),

          // Collapse Toggle
          _CollapseToggle(isCollapsed: isCollapsed, isDark: isDark),
        ],
      ),
    );
  }
}

/// Sidebar header with gradient logo
class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({
    required this.isCollapsed,
    required this.isDark,
  });

  final bool isCollapsed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
      child: Row(
        children: [
          // AmoMaherTec Logo
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                    child: Image.asset(
                      'assets/logo_without_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          if (!isCollapsed) ...[
            SizedBox(width: AppConstants.paddingSM),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(-10 * (1 - value), 0),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            AppColors.primary,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          AppLocalizations.of(context)!.adminDashboard,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Sidebar navigation item with enhanced animations
class _SidebarNavItem extends StatefulWidget {
  const _SidebarNavItem({
    required this.item,
    required this.isActive,
    required this.isCollapsed,
    required this.isDark,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  final NavItem item;
  final bool isActive;
  final bool isCollapsed;
  final bool isDark;
  final VoidCallback onTap;
  final Duration animationDelay;

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String _getLocalizedLabel(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;
    switch (label.toLowerCase()) {
      case 'dashboard':
        return l10n.dashboard;
      case 'users':
        return l10n.users;
      case 'analytics':
        return l10n.analytics;
      case 'settings':
        return l10n.settings;
      default:
        return label;
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_SidebarNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isDark
        ? AppColors.sidebarActiveDark
        : AppColors.sidebarActiveLight;
    final textColor = widget.isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final iconColor = widget.isActive
        ? AppColors.primary
        : (widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
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
      child: Padding(
        padding: EdgeInsets.only(bottom: AppConstants.paddingXS),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isActive ? _pulseAnimation.value : 1.0,
                child: child,
              );
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                child: AnimatedContainer(
                  duration: AppConstants.animationFast,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMD,
                    vertical: AppConstants.paddingSM + 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: widget.isActive
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              activeColor,
                              activeColor.withValues(alpha: 0.5),
                            ],
                          )
                        : (_isHovered
                            ? LinearGradient(
                                colors: [
                                  activeColor.withValues(alpha: 0.3),
                                  activeColor.withValues(alpha: 0.1),
                                ],
                              )
                            : null),
                    color: widget.isActive || _isHovered ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                    border: widget.isActive
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Icon with glow effect when active
                      AnimatedContainer(
                        duration: AppConstants.animationFast,
                        child: Icon(
                          widget.item.icon,
                          size: 22,
                          color: iconColor,
                          shadows: widget.isActive
                              ? [
                                  Shadow(
                                    color: AppColors.primary.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      if (!widget.isCollapsed) ...[
                        SizedBox(width: AppConstants.paddingMD),
                        Expanded(
                          child: Text(
                            _getLocalizedLabel(context, widget.item.label),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  widget.isActive ? FontWeight.w600 : FontWeight.w500,
                              color: widget.isActive ? AppColors.primary : textColor,
                            ),
                          ),
                        ),
                        // Active indicator dot
                        if (widget.isActive)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Collapse toggle button with rotation animation
class _CollapseToggle extends StatefulWidget {
  const _CollapseToggle({
    required this.isCollapsed,
    required this.isDark,
  });

  final bool isCollapsed;
  final bool isDark;

  @override
  State<_CollapseToggle> createState() => _CollapseToggleState();
}

class _CollapseToggleState extends State<_CollapseToggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final navProvider = context.read<NavigationProvider>();

    return Container(
      padding: EdgeInsets.all(AppConstants.paddingSM),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isDark
                    ? AppColors.darkBackground.withValues(alpha: 0.5)
                    : AppColors.lightBackground)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          ),
          child: IconButton(
            onPressed: navProvider.toggleSidebarCollapsed,
            tooltip: AppLocalizations.of(context)!.toggleSidebar,
            icon: AnimatedRotation(
              turns: widget.isCollapsed ? 0.5 : 0,
              duration: AppConstants.animationNormal,
              child: Icon(
                Icons.chevron_left_rounded,
                color: _isHovered
                    ? AppColors.primary
                    : (widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Powered by AmoMaherTec footer
class _PoweredByFooter extends StatelessWidget {
  const _PoweredByFooter({
    required this.isCollapsed,
    required this.isDark,
  });

  final bool isCollapsed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      // Show only AmoMaherTec logo when collapsed
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppConstants.paddingSM),
        child: Tooltip(
          message: '© ${DateTime.now().year} AmoMaherTec',
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/logo_without_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingSM),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/logo_without_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                ).createShader(bounds),
                child: Text(
                  '${AppLocalizations.of(context)!.poweredBy} AmoMaherTec',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '© ${DateTime.now().year} AmoMaherTec',
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
