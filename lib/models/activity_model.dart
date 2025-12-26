/// Activity model for the admin dashboard
class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.action,
    required this.status,
    required this.timestamp,
    this.details,
  });

  final String id;
  final String userName;
  final String userAvatar;
  final String action;
  final ActivityStatus status;
  final DateTime timestamp;
  final String? details;
}

/// Activity status
enum ActivityStatus {
  success('Success'),
  pending('Pending'),
  failed('Failed'),
  warning('Warning');

  const ActivityStatus(this.label);
  final String label;
}
