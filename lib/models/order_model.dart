/// Order model for the admin dashboard
class OrderModel {
  const OrderModel({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.amount,
    required this.status,
    required this.date,
    this.items = const [],
  });

  final String id;
  final String customerName;
  final String customerEmail;
  final double amount;
  final OrderStatus status;
  final DateTime date;
  final List<String> items;

  /// Create a copy with updated values
  OrderModel copyWith({
    String? id,
    String? customerName,
    String? customerEmail,
    double? amount,
    OrderStatus? status,
    DateTime? date,
    List<String>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }
}

/// Order status
enum OrderStatus {
  pending('Pending'),
  processing('Processing'),
  completed('Completed'),
  cancelled('Cancelled'),
  refunded('Refunded');

  const OrderStatus(this.label);
  final String label;
}
