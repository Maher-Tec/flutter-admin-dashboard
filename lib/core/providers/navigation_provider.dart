import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Navigation provider for managing sidebar and page state
class NavigationProvider extends ChangeNotifier {
  NavItem _currentItem = NavItem.dashboard;
  bool _isSidebarCollapsed = false;
  bool _isSidebarVisible = true;

  /// Current selected navigation item
  NavItem get currentItem => _currentItem;

  /// Current page index
  int get currentIndex => _currentItem.index;

  /// Whether sidebar is collapsed (icon-only mode)
  bool get isSidebarCollapsed => _isSidebarCollapsed;

  /// Whether sidebar is visible (for mobile drawer)
  bool get isSidebarVisible => _isSidebarVisible;

  /// Navigate to a specific item
  void navigateTo(NavItem item) {
    if (_currentItem != item) {
      _currentItem = item;
      notifyListeners();
    }
  }

  /// Navigate by index
  void navigateToIndex(int index) {
    if (index >= 0 && index < NavItem.values.length) {
      navigateTo(NavItem.values[index]);
    }
  }

  /// Toggle sidebar collapsed state
  void toggleSidebarCollapsed() {
    _isSidebarCollapsed = !_isSidebarCollapsed;
    notifyListeners();
  }

  /// Set sidebar collapsed state
  void setSidebarCollapsed(bool collapsed) {
    if (_isSidebarCollapsed != collapsed) {
      _isSidebarCollapsed = collapsed;
      notifyListeners();
    }
  }

  /// Toggle sidebar visibility (for mobile)
  void toggleSidebarVisibility() {
    _isSidebarVisible = !_isSidebarVisible;
    notifyListeners();
  }

  /// Set sidebar visibility
  void setSidebarVisible(bool visible) {
    if (_isSidebarVisible != visible) {
      _isSidebarVisible = visible;
      notifyListeners();
    }
  }
}
