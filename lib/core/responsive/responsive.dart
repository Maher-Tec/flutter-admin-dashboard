import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Device type enum
enum DeviceType { mobile, tablet, desktop }

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= AppConstants.mobileBreakpoint) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// Extension methods for responsive sizing
extension ResponsiveExtension on BuildContext {
  /// Get current device type
  DeviceType get deviceType {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= AppConstants.tabletBreakpoint) return DeviceType.desktop;
    if (width >= AppConstants.mobileBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Check if current device is mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if current device is tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if current device is desktop
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Get screen width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Get screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Responsive value based on device type
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  /// Get number of columns for grid
  int get gridCrossAxisCount {
    switch (deviceType) {
      case DeviceType.desktop:
        return 4;
      case DeviceType.tablet:
        return 2;
      case DeviceType.mobile:
        return 1;
    }
  }
}
