import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
class DetectionStats {
  final int totalMessages;
  final int toxicMessages;
  final int blockedMessages;
  final int reportsGenerated;
  final double toxicityRate;

  DetectionStats({
    required this.totalMessages,
    required this.toxicMessages,
    required this.blockedMessages,
    required this.reportsGenerated,
    required this.toxicityRate,
  });
}

class Report {
  final String id;
  final String content;
  final String reportedBy;
  final DateTime timestamp;
  final String severity;
  final String status;
  final String category;

  Report({
    required this.id,
    required this.content,
    required this.reportedBy,
    required this.timestamp,
    required this.severity,
    required this.status,
    required this.category,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime lastActive;
  final int reportCount;
  final String status;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.lastActive,
    required this.reportCount,
    required this.status,
  });
}

// State Providers
final selectedTabProvider = StateProvider<int>((ref) => 0);

final detectionStatsProvider =
    StateProvider<DetectionStats>((ref) => DetectionStats(
          totalMessages: 25847,
          toxicMessages: 1247,
          blockedMessages: 892,
          reportsGenerated: 234,
          toxicityRate: 4.8,
        ));

final reportsProvider = StateProvider<List<Report>>((ref) => [
      Report(
        id: 'R001',
        content: 'Inappropriate language targeting student',
        reportedBy: 'Anonymous',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        severity: 'High',
        status: 'Pending',
        category: 'Bullying',
      ),
      Report(
        id: 'R002',
        content: 'Threatening behavior in group chat',
        reportedBy: 'Teacher',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        severity: 'Critical',
        status: 'Under Review',
        category: 'Threats',
      ),
      Report(
        id: 'R003',
        content: 'Harassment via direct messages',
        reportedBy: 'Student',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        severity: 'Medium',
        status: 'Resolved',
        category: 'Harassment',
      ),
    ]);

final usersProvider = StateProvider<List<User>>((ref) => [
      User(
        id: 'U001',
        name: 'John Doe',
        email: 'john@school.edu',
        role: 'Student',
        lastActive: DateTime.now().subtract(Duration(minutes: 30)),
        reportCount: 0,
        status: 'Active',
      ),
      User(
        id: 'U002',
        name: 'Sarah Smith',
        email: 'sarah@school.edu',
        role: 'Teacher',
        lastActive: DateTime.now().subtract(Duration(hours: 2)),
        reportCount: 3,
        status: 'Active',
      ),
      User(
        id: 'U003',
        name: 'Mike Johnson',
        email: 'mike@school.edu',
        role: 'Student',
        lastActive: DateTime.now().subtract(Duration(days: 2)),
        reportCount: 1,
        status: 'Suspended',
      ),
    ]);
