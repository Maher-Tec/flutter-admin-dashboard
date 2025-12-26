import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/order_model.dart';

/// Orders management screen
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrderStatus? _statusFilter;

  List<OrderModel> get _filteredOrders {
    if (_statusFilter == null) return MockData.orders;
    return MockData.orders.where((order) => order.status == _statusFilter).toList();
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
                    'Orders',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${MockData.orders.length} orders total',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.file_download_rounded, size: 20),
                label: Text('Export'),
              ),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingLG),
          
          // Status Filters
          _StatusFilters(
            selectedStatus: _statusFilter,
            onStatusChanged: (status) => setState(() => _statusFilter = status),
            isDark: isDark,
          ),
          
          SizedBox(height: AppConstants.paddingMD),
          
          // Orders List
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
                      Expanded(flex: 1, child: _HeaderText('Order ID', isDark)),
                      Expanded(flex: 2, child: _HeaderText('Customer', isDark)),
                      Expanded(flex: 1, child: _HeaderText('Amount', isDark)),
                      Expanded(flex: 1, child: _HeaderText('Status', isDark)),
                      Expanded(flex: 2, child: _HeaderText('Date', isDark)),
                      SizedBox(width: 50, child: _HeaderText('', isDark)),
                    ],
                  ),
                ),
                // Order Rows
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _filteredOrders.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  ),
                  itemBuilder: (context, index) {
                    return _OrderRow(
                      order: _filteredOrders[index],
                      isDark: isDark,
                      onViewDetails: () => _showOrderDetails(context, _filteredOrders[index]),
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

  void _showOrderDetails(BuildContext context, OrderModel order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        title: Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Order ${order.id}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Customer', order.customerName),
            _DetailRow('Email', order.customerEmail),
            _DetailRow('Amount', '\$${order.amount.toStringAsFixed(2)}'),
            _DetailRow('Status', order.status.label),
            _DetailRow('Date', _formatDate(order.date)),
            SizedBox(height: AppConstants.paddingMD),
            Text(
              'Items',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: 8),
            ...order.items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 16, color: AppColors.success),
                      SizedBox(width: 8),
                      Text(item),
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Detail row for order dialog
class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Status filter chips
class _StatusFilters extends StatelessWidget {
  const _StatusFilters({
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.isDark,
  });

  final OrderStatus? selectedStatus;
  final ValueChanged<OrderStatus?> onStatusChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.paddingSM,
      runSpacing: AppConstants.paddingSM,
      children: [
        _FilterChip(
          label: 'All',
          isSelected: selectedStatus == null,
          onTap: () => onStatusChanged(null),
          isDark: isDark,
        ),
        ...OrderStatus.values.map((status) => _FilterChip(
              label: status.label,
              isSelected: selectedStatus == status,
              onTap: () => onStatusChanged(status),
              isDark: isDark,
              color: _getStatusColor(status),
            )),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.processing:
        return AppColors.info;
      case OrderStatus.completed:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
      case OrderStatus.refunded:
        return AppColors.accent;
    }
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusXL),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppColors.primary)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.primary)
                : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ),
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

/// Order row widget
class _OrderRow extends StatefulWidget {
  const _OrderRow({
    required this.order,
    required this.isDark,
    required this.onViewDetails,
  });

  final OrderModel order;
  final bool isDark;
  final VoidCallback onViewDetails;

  @override
  State<_OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<_OrderRow> {
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
            // Order ID
            Expanded(
              flex: 1,
              child: Text(
                widget.order.id,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Customer
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.customerName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: widget.isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.order.customerEmail,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Amount
            Expanded(
              flex: 1,
              child: Text(
                '\$${widget.order.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            // Status
            Expanded(
              flex: 1,
              child: _OrderStatusBadge(status: widget.order.status),
            ),
            // Date
            Expanded(
              flex: 2,
              child: Text(
                _formatDate(widget.order.date),
                style: TextStyle(
                  fontSize: 13,
                  color: widget.isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            // View Details Button
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: widget.onViewDetails,
                tooltip: 'View Details',
                icon: Icon(Icons.visibility_rounded, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Order status badge
class _OrderStatusBadge extends StatelessWidget {
  const _OrderStatusBadge({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case OrderStatus.pending:
        bgColor = AppColors.warningLight;
        textColor = AppColors.warning;
        break;
      case OrderStatus.processing:
        bgColor = AppColors.infoLight;
        textColor = AppColors.info;
        break;
      case OrderStatus.completed:
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
        break;
      case OrderStatus.cancelled:
        bgColor = AppColors.errorLight;
        textColor = AppColors.error;
        break;
      case OrderStatus.refunded:
        bgColor = AppColors.accent.withValues(alpha: 0.1);
        textColor = AppColors.accent;
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
