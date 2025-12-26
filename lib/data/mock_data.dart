import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/activity_model.dart';

/// Mock data for the admin dashboard
class MockData {
  MockData._();

  // ============ KPI Data ============
  static const int totalUsers = 12847;
  static const int activeOrders = 284;
  static const double revenue = 48293.50;
  static const double growthPercentage = 12.5;

  static const double usersChange = 8.2;
  static const double ordersChange = -3.1;
  static const double revenueChange = 15.7;

  // ============ Chart Data ============
  
  /// Weekly growth data (last 7 days)
  static final List<ChartDataPoint> weeklyGrowth = [
    ChartDataPoint(label: 'Mon', value: 2400),
    ChartDataPoint(label: 'Tue', value: 1398),
    ChartDataPoint(label: 'Wed', value: 9800),
    ChartDataPoint(label: 'Thu', value: 3908),
    ChartDataPoint(label: 'Fri', value: 4800),
    ChartDataPoint(label: 'Sat', value: 3800),
    ChartDataPoint(label: 'Sun', value: 4300),
  ];

  /// Daily activity data
  static final List<ChartDataPoint> dailyActivity = [
    ChartDataPoint(label: 'Mon', value: 65),
    ChartDataPoint(label: 'Tue', value: 59),
    ChartDataPoint(label: 'Wed', value: 80),
    ChartDataPoint(label: 'Thu', value: 81),
    ChartDataPoint(label: 'Fri', value: 56),
    ChartDataPoint(label: 'Sat', value: 55),
    ChartDataPoint(label: 'Sun', value: 40),
  ];

  /// Monthly revenue data
  static final List<ChartDataPoint> monthlyRevenue = [
    ChartDataPoint(label: 'Jan', value: 12000),
    ChartDataPoint(label: 'Feb', value: 19000),
    ChartDataPoint(label: 'Mar', value: 15000),
    ChartDataPoint(label: 'Apr', value: 22000),
    ChartDataPoint(label: 'May', value: 28000),
    ChartDataPoint(label: 'Jun', value: 24000),
    ChartDataPoint(label: 'Jul', value: 31000),
    ChartDataPoint(label: 'Aug', value: 29000),
    ChartDataPoint(label: 'Sep', value: 35000),
    ChartDataPoint(label: 'Oct', value: 38000),
    ChartDataPoint(label: 'Nov', value: 42000),
    ChartDataPoint(label: 'Dec', value: 48000),
  ];

  // ============ Users Data ============
  static final List<UserModel> users = [
    UserModel(
      id: 'USR001',
      name: 'John Smith',
      email: 'john.smith@email.com',
      avatar: 'https://i.pravatar.cc/150?img=1',
      role: UserRole.admin,
      status: UserStatus.active,
      createdAt: DateTime.now().subtract(Duration(days: 120)),
    ),
    UserModel(
      id: 'USR002',
      name: 'Sarah Johnson',
      email: 'sarah.j@email.com',
      avatar: 'https://i.pravatar.cc/150?img=5',
      role: UserRole.user,
      status: UserStatus.active,
      createdAt: DateTime.now().subtract(Duration(days: 85)),
    ),
    UserModel(
      id: 'USR003',
      name: 'Mike Wilson',
      email: 'mike.wilson@email.com',
      avatar: 'https://i.pravatar.cc/150?img=3',
      role: UserRole.moderator,
      status: UserStatus.active,
      createdAt: DateTime.now().subtract(Duration(days: 60)),
    ),
    UserModel(
      id: 'USR004',
      name: 'Emily Brown',
      email: 'emily.b@email.com',
      avatar: 'https://i.pravatar.cc/150?img=9',
      role: UserRole.user,
      status: UserStatus.blocked,
      createdAt: DateTime.now().subtract(Duration(days: 200)),
    ),
    UserModel(
      id: 'USR005',
      name: 'David Lee',
      email: 'david.lee@email.com',
      avatar: 'https://i.pravatar.cc/150?img=8',
      role: UserRole.user,
      status: UserStatus.pending,
      createdAt: DateTime.now().subtract(Duration(days: 5)),
    ),
    UserModel(
      id: 'USR006',
      name: 'Lisa Garcia',
      email: 'lisa.g@email.com',
      avatar: 'https://i.pravatar.cc/150?img=25',
      role: UserRole.user,
      status: UserStatus.active,
      createdAt: DateTime.now().subtract(Duration(days: 45)),
    ),
    UserModel(
      id: 'USR007',
      name: 'James Taylor',
      email: 'james.t@email.com',
      avatar: 'https://i.pravatar.cc/150?img=11',
      role: UserRole.moderator,
      status: UserStatus.active,
      createdAt: DateTime.now().subtract(Duration(days: 90)),
    ),
    UserModel(
      id: 'USR008',
      name: 'Emma White',
      email: 'emma.w@email.com',
      avatar: 'https://i.pravatar.cc/150?img=32',
      role: UserRole.user,
      status: UserStatus.active,
      createdAt: DateTime.now().subtract(Duration(days: 30)),
    ),
  ];

  // ============ Orders Data ============
  static final List<OrderModel> orders = [
    OrderModel(
      id: 'ORD001',
      customerName: 'John Smith',
      customerEmail: 'john.smith@email.com',
      amount: 259.99,
      status: OrderStatus.completed,
      date: DateTime.now().subtract(Duration(hours: 2)),
      items: ['Product A', 'Product B'],
    ),
    OrderModel(
      id: 'ORD002',
      customerName: 'Sarah Johnson',
      customerEmail: 'sarah.j@email.com',
      amount: 149.50,
      status: OrderStatus.processing,
      date: DateTime.now().subtract(Duration(hours: 5)),
      items: ['Product C'],
    ),
    OrderModel(
      id: 'ORD003',
      customerName: 'Mike Wilson',
      customerEmail: 'mike.wilson@email.com',
      amount: 89.99,
      status: OrderStatus.pending,
      date: DateTime.now().subtract(Duration(hours: 8)),
      items: ['Product D', 'Product E', 'Product F'],
    ),
    OrderModel(
      id: 'ORD004',
      customerName: 'Emily Brown',
      customerEmail: 'emily.b@email.com',
      amount: 399.00,
      status: OrderStatus.completed,
      date: DateTime.now().subtract(Duration(days: 1)),
      items: ['Product G'],
    ),
    OrderModel(
      id: 'ORD005',
      customerName: 'David Lee',
      customerEmail: 'david.lee@email.com',
      amount: 75.25,
      status: OrderStatus.cancelled,
      date: DateTime.now().subtract(Duration(days: 1, hours: 4)),
      items: ['Product H'],
    ),
    OrderModel(
      id: 'ORD006',
      customerName: 'Lisa Garcia',
      customerEmail: 'lisa.g@email.com',
      amount: 520.00,
      status: OrderStatus.completed,
      date: DateTime.now().subtract(Duration(days: 2)),
      items: ['Product I', 'Product J'],
    ),
    OrderModel(
      id: 'ORD007',
      customerName: 'James Taylor',
      customerEmail: 'james.t@email.com',
      amount: 185.75,
      status: OrderStatus.refunded,
      date: DateTime.now().subtract(Duration(days: 3)),
      items: ['Product K'],
    ),
    OrderModel(
      id: 'ORD008',
      customerName: 'Emma White',
      customerEmail: 'emma.w@email.com',
      amount: 299.99,
      status: OrderStatus.processing,
      date: DateTime.now().subtract(Duration(days: 1)),
      items: ['Product L', 'Product M'],
    ),
  ];

  // ============ Activity Data ============
  static final List<ActivityModel> activities = [
    ActivityModel(
      id: 'ACT001',
      userName: 'John Smith',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      action: 'Created new order #ORD001',
      status: ActivityStatus.success,
      timestamp: DateTime.now().subtract(Duration(minutes: 15)),
    ),
    ActivityModel(
      id: 'ACT002',
      userName: 'Sarah Johnson',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      action: 'Updated profile settings',
      status: ActivityStatus.success,
      timestamp: DateTime.now().subtract(Duration(minutes: 32)),
    ),
    ActivityModel(
      id: 'ACT003',
      userName: 'System',
      userAvatar: 'https://i.pravatar.cc/150?img=60',
      action: 'Payment processing failed for #ORD005',
      status: ActivityStatus.failed,
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
    ActivityModel(
      id: 'ACT004',
      userName: 'Mike Wilson',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      action: 'Added new product to inventory',
      status: ActivityStatus.success,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    ActivityModel(
      id: 'ACT005',
      userName: 'Emily Brown',
      userAvatar: 'https://i.pravatar.cc/150?img=9',
      action: 'Requested account reactivation',
      status: ActivityStatus.pending,
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
    ),
    ActivityModel(
      id: 'ACT006',
      userName: 'David Lee',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      action: 'Cancelled order #ORD005',
      status: ActivityStatus.warning,
      timestamp: DateTime.now().subtract(Duration(hours: 4)),
    ),
    ActivityModel(
      id: 'ACT007',
      userName: 'Lisa Garcia',
      userAvatar: 'https://i.pravatar.cc/150?img=25',
      action: 'Completed purchase #ORD006',
      status: ActivityStatus.success,
      timestamp: DateTime.now().subtract(Duration(hours: 6)),
    ),
    ActivityModel(
      id: 'ACT008',
      userName: 'James Taylor',
      userAvatar: 'https://i.pravatar.cc/150?img=11',
      action: 'Refunded order #ORD007',
      status: ActivityStatus.success,
      timestamp: DateTime.now().subtract(Duration(hours: 8)),
    ),
  ];
}

/// Data point for charts
class ChartDataPoint {
  const ChartDataPoint({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}
