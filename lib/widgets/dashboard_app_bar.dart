import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/constants.dart';
import '../core/theme/app_colors.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/navigation_provider.dart';
import '../core/providers/language_provider.dart';
import 'package:admin_dash/l10n/app_localizations.dart';

/// Dashboard app bar widget with premium effects
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
    this.onMenuPressed,
  });

  final VoidCallback? onMenuPressed;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final isDark = themeProvider.isDarkMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < AppConstants.mobileBreakpoint;
        final isVerySmall = screenWidth < 400;

        return Container(
          height: 72,
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmall ? AppConstants.paddingMD : AppConstants.paddingLG,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface.withValues(alpha: 0.95)
                : AppColors.lightSurface.withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Menu button (mobile only)
              if (onMenuPressed != null) ...[
                _AnimatedIconButton(
                  icon: Icons.menu_rounded,
                  onPressed: onMenuPressed!,
                  isDark: isDark,
                ),
                SizedBox(width: isVerySmall ? AppConstants.paddingXS : AppConstants.paddingSM),
              ],

              // Page Title with animation
              if (!isVerySmall)
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(navProvider.currentItem),
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(-10 * (1 - value), 0),
                          child: Text(
                            _getLocalizedLabel(context, navProvider.currentItem.label),
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 24,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              if (!isVerySmall) const SizedBox(width: AppConstants.paddingMD),
              if (isVerySmall) const Spacer(),

              // Search Bar (desktop only)
              _SearchBar(isDark: isDark),

              if (_SearchBar.isVisible(context)) 
                SizedBox(width: AppConstants.paddingMD),

              // Notification Button
              _NotificationButton(isDark: isDark),

              SizedBox(width: isVerySmall ? AppConstants.paddingXS : AppConstants.paddingSM),

              // Theme Toggle
              _ThemeToggle(isDark: isDark),

              SizedBox(width: isMobile ? AppConstants.paddingSM : AppConstants.paddingMD),

              // Language Selector
              _LanguageSelector(isDark: isDark),

              SizedBox(width: isVerySmall ? AppConstants.paddingXS : AppConstants.paddingSM),

              // Profile Avatar
              _ProfileAvatar(
                isDark: isDark,
                showLabels: screenWidth > 550,
              ),
            ],
          ),
        );
      },
    );
  }

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
}

/// Animated icon button
class _AnimatedIconButton extends StatefulWidget {
  const _AnimatedIconButton({
    required this.icon,
    required this.onPressed,
    required this.isDark,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton> {
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
              ? (widget.isDark
                  ? AppColors.darkBackground.withValues(alpha: 0.5)
                  : AppColors.lightBackground)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
        ),
        child: IconButton(
          onPressed: widget.onPressed,
          icon: Icon(
            widget.icon,
            color: _isHovered ? AppColors.primary : null,
          ),
        ),
      ),
    );
  }
}

/// Search bar widget with focus animation
class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.isDark});

  final bool isDark;

  static bool isVisible(BuildContext context) => MediaQuery.sizeOf(context).width >= 800;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_SearchBar.isVisible(context)) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: AppConstants.animationFast,
      width: _isFocused ? 320 : 280,
      height: 44,
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusSM),
        border: Border.all(
          color: _isFocused
              ? AppColors.primary
              : (widget.isDark ? AppColors.darkDivider : AppColors.lightDivider),
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: TextStyle(
            color: widget.isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
            fontSize: 14,
          ),
          prefixIcon: AnimatedContainer(
            duration: AppConstants.animationFast,
            child: Icon(
              Icons.search_rounded,
              color: _isFocused
                  ? AppColors.primary
                  : (widget.isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary),
              size: 20,
            ),
          ),
          suffixIcon: _isFocused
              ? IconButton(
                  onPressed: () => _focusNode.unfocus(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: widget.isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMD,
            vertical: 12,
          ),
        ),
        style: TextStyle(
          fontSize: 14,
          color: widget.isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}

/// Language Selector
class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<Locale>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark 
              ? AppColors.darkSurface.withValues(alpha: 0.5)
              : AppColors.lightSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              languageProvider.currentLocale.languageCode.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
      onSelected: (Locale locale) {
        languageProvider.setLocale(locale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: _LanguageItem(label: l10n.english, code: 'EN', isSelected: languageProvider.currentLocale.languageCode == 'en'),
        ),
        PopupMenuItem(
          value: const Locale('fr'),
          child: _LanguageItem(label: l10n.french, code: 'FR', isSelected: languageProvider.currentLocale.languageCode == 'fr'),
        ),
        PopupMenuItem(
          value: const Locale('ar'),
          child: _LanguageItem(label: l10n.arabic, code: 'AR', isSelected: languageProvider.currentLocale.languageCode == 'ar'),
        ),
      ],
    );
  }
}

class _LanguageItem extends StatelessWidget {
  const _LanguageItem({required this.label, required this.code, required this.isSelected});
  final String label;
  final String code;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 10,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(label),
        const Spacer(),
        if (isSelected)
          const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
      ],
    );
  }
}

/// Notification button with pulse animation
class _NotificationButton extends StatefulWidget {
  const _NotificationButton({required this.isDark});

  final bool isDark;

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MouseRegion(
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
        child: Stack(
          children: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.notifications_outlined, color: Colors.white),
                        const SizedBox(width: 12),
                        const Text(' '),
                        Text(l10n.noNotifications),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: widget.isDark
                        ? AppColors.darkCard
                        : AppColors.lightTextPrimary,
                  ),
                );
              },
              tooltip: l10n.notifications,
              icon: Icon(
                Icons.notifications_outlined,
                color: _isHovered
                    ? AppColors.primary
                    : (widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Theme toggle button with enhanced animation
class _ThemeToggle extends StatefulWidget {
  const _ThemeToggle({required this.isDark});

  final bool isDark;

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.read<ThemeProvider>();

    return MouseRegion(
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
          onPressed: themeProvider.toggleTheme,
          tooltip: widget.isDark ? l10n.switchToLightMode : l10n.switchToDarkMode,
          icon: AnimatedSwitcher(
            duration: AppConstants.animationFast,
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                child: ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Icon(
              widget.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(widget.isDark),
              color: _isHovered
                  ? (widget.isDark ? AppColors.warning : AppColors.primary)
                  : (widget.isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

/// Profile avatar with glass dropdown
class _ProfileAvatar extends StatefulWidget {
  const _ProfileAvatar({
    required this.isDark,
    this.showLabels = true,
  });

  final bool isDark;
  final bool showLabels;

  @override
  State<_ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<_ProfileAvatar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _isHovered
              ? (widget.isDark
                  ? AppColors.darkBackground.withValues(alpha: 0.5)
                  : AppColors.lightBackground)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: PopupMenuButton<String>(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
          child: Row(
            children: [
              // Gradient avatar ring
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: _isHovered ? AppColors.primaryGradient : null,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor:
                      widget.isDark ? AppColors.darkCard : AppColors.lightCard,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: ClipOval(
                      child: Image.network(
                        'https://i.pravatar.cc/150?img=5',
                        errorBuilder: (context, error, stackTrace) => const Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Only show name/email on larger screens
              if (widget.showLabels) ...[
                SizedBox(width: AppConstants.paddingSM),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.adminUser,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'admin@example.com',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppConstants.paddingSM),
                AnimatedRotation(
                  turns: _isHovered ? 0.5 : 0,
                  duration: AppConstants.animationFast,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.person_outline_rounded,
                        size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.profile),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.settings_outlined,
                        size: 18, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.settings),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.logout_rounded,
                        size: 18, color: AppColors.error),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.logout, style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'settings') {
              context.read<NavigationProvider>().navigateTo(NavItem.settings);
            }
          },
        ),
      ),
    );
  }
}
