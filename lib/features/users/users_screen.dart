import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/user_model.dart';

/// Users management screen
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _searchQuery = '';
  UserRole? _roleFilter;
  UserStatus? _statusFilter;

  List<UserModel> get _filteredUsers {
    return MockData.users.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _roleFilter == null || user.role == _roleFilter;
      final matchesStatus = _statusFilter == null || user.status == _statusFilter;
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${MockData.users.length} users total',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(context),
                icon: Icon(Icons.add_rounded, size: 20),
                label: Text('Add User'),
              ),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingLG),
          
          // Filters
          _FiltersSection(
            searchQuery: _searchQuery,
            roleFilter: _roleFilter,
            statusFilter: _statusFilter,
            onSearchChanged: (value) => setState(() => _searchQuery = value),
            onRoleChanged: (value) => setState(() => _roleFilter = value),
            onStatusChanged: (value) => setState(() => _statusFilter = value),
            isDark: isDark,
          ),
          
          SizedBox(height: AppConstants.paddingMD),
          
          // Users List
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              border: Border.all(
                color: isDark
                    ? AppColors.darkDivider.withValues(alpha: 0.5)
                    : AppColors.lightDivider.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusMD),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _HeaderText('User', isDark)),
                      Expanded(flex: 2, child: _HeaderText('Email', isDark)),
                      Expanded(flex: 1, child: _HeaderText('Role', isDark)),
                      Expanded(flex: 1, child: _HeaderText('Status', isDark)),
                      SizedBox(width: 50, child: _HeaderText('', isDark)),
                    ],
                  ),
                ),
                // User Rows
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _filteredUsers.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  ),
                  itemBuilder: (context, index) {
                    return _UserRow(
                      user: _filteredUsers[index],
                      isDark: isDark,
                      onEdit: () => _showEditUserDialog(context, _filteredUsers[index]),
                      onDelete: () => _showDeleteConfirmation(context, _filteredUsers[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New User'),
        content: Text('This is a demo. In production, this would open a form to add a new user.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: Text('Editing: ${user.name}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User deleted (demo)')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Filters section
class _FiltersSection extends StatelessWidget {
  const _FiltersSection({
    required this.searchQuery,
    required this.roleFilter,
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onRoleChanged,
    required this.onStatusChanged,
    required this.isDark,
  });

  final String searchQuery;
  final UserRole? roleFilter;
  final UserStatus? statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<UserRole?> onRoleChanged;
  final ValueChanged<UserStatus?> onStatusChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.paddingMD,
      runSpacing: AppConstants.paddingMD,
      children: [
        // Search
        SizedBox(
          width: 250,
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: Icon(Icons.search_rounded, size: 20),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMD,
                vertical: AppConstants.paddingSM,
              ),
            ),
          ),
        ),
        // Role Filter
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserRole?>(
              value: roleFilter,
              hint: Text('All Roles'),
              items: [
                DropdownMenuItem(value: null, child: Text('All Roles')),
                ...UserRole.values.map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role.label),
                    )),
              ],
              onChanged: onRoleChanged,
            ),
          ),
        ),
        // Status Filter
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserStatus?>(
              value: statusFilter,
              hint: Text('All Status'),
              items: [
                DropdownMenuItem(value: null, child: Text('All Status')),
                ...UserStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    )),
              ],
              onChanged: onStatusChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Header text
class _HeaderText extends StatelessWidget {
  const _HeaderText(this.text, this.isDark);

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }
}

/// User row widget
class _UserRow extends StatefulWidget {
  const _UserRow({
    required this.user,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel user;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_UserRow> createState() => _UserRowState();
}

class _UserRowState extends State<_UserRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        color: _isHovered
            ? (widget.isDark
                ? AppColors.darkBackground.withValues(alpha: 0.3)
                : AppColors.lightBackground.withValues(alpha: 0.5))
            : Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLG,
          vertical: AppConstants.paddingMD,
        ),
        child: Row(
          children: [
            // User Info
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: widget.isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                    child: ClipOval(
                      child: Image.network(
                        widget.user.avatar,
                        errorBuilder: (context, error, stackTrace) => Text(
                          widget.user.name[0],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingSM),
                  Expanded(
                    child: Text(
                      widget.user.name,
                      style: TextStyle(
                        fontSize: 14,
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
            // Email
            Expanded(
              flex: 2,
              child: Text(
                widget.user.email,
                style: TextStyle(
                  fontSize: 13,
                  color: widget.isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Role Badge
            Expanded(
              flex: 1,
              child: _RoleBadge(role: widget.user.role),
            ),
            // Status Badge
            Expanded(
              flex: 1,
              child: _StatusBadge(status: widget.user.status),
            ),
            // Actions
            SizedBox(
              width: 50,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, size: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') widget.onEdit();
                  if (value == 'delete') widget.onDelete();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Role badge
class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (role) {
      case UserRole.admin:
        bgColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        break;
      case UserRole.moderator:
        bgColor = AppColors.accent.withValues(alpha: 0.1);
        textColor = AppColors.accent;
        break;
      case UserRole.user:
        bgColor = AppColors.lightTextTertiary.withValues(alpha: 0.2);
        textColor = AppColors.lightTextSecondary;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSM,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

/// Status badge
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final UserStatus status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case UserStatus.active:
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
        break;
      case UserStatus.blocked:
        bgColor = AppColors.errorLight;
        textColor = AppColors.error;
        break;
      case UserStatus.pending:
        bgColor = AppColors.warningLight;
        textColor = AppColors.warning;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSM,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
