import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:safespeak/Providers/DashboardProvider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.security, size: 28),
            SizedBox(width: 8),
            Text('SafeSpeak Admin',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => _showProfile(context),
          ),
        ],
      ),
      body: isDesktop
          ? _buildDesktopLayout(context, ref)
          : _buildMobileLayout(context, ref),
      bottomNavigationBar:
          isDesktop ? null : _buildBottomNavigation(context, ref),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Row(
      children: [
        // Sidebar
        Container(
          width: 250,
          color: Colors.white,
          child: Column(
            children: [
              _buildSidebarItem(context, ref, 0, Icons.dashboard, 'Dashboard'),
              _buildSidebarItem(
                  context, ref, 1, Icons.report_problem, 'Reports'),
              _buildSidebarItem(context, ref, 2, Icons.people, 'Users'),
              _buildSidebarItem(context, ref, 3, Icons.analytics, 'Analytics'),
              _buildSidebarItem(context, ref, 4, Icons.settings, 'Settings'),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: _buildTabContent(context, ref, selectedTab),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    return _buildTabContent(context, ref, selectedTab);
  }

  Widget _buildSidebarItem(BuildContext context, WidgetRef ref, int index,
      IconData icon, String title) {
    final selectedTab = ref.watch(selectedTabProvider);
    final isSelected = selectedTab == index;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading:
            Icon(icon, color: isSelected ? Colors.blue[700] : Colors.grey[600]),
        title: Text(title,
            style: TextStyle(
              color: isSelected ? Colors.blue[700] : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            )),
        selected: isSelected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () => ref.read(selectedTabProvider.notifier).state = index,
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return BottomNavigationBar(
      currentIndex: selectedTab,
      onTap: (index) => ref.read(selectedTabProvider.notifier).state = index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue[700],
      unselectedItemColor: Colors.grey[600],
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.report_problem), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
        BottomNavigationBarItem(
            icon: Icon(Icons.analytics), label: 'Analytics'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  Widget _buildTabContent(
      BuildContext context, WidgetRef ref, int selectedTab) {
    switch (selectedTab) {
      case 0:
        return DashboardTab();
      case 1:
        return ReportsTab();
      case 2:
        return UsersTab();
      case 3:
        return AnalyticsTab();
      case 4:
        return SettingsTab();
      default:
        return DashboardTab();
    }
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.warning, color: Colors.red),
              title: Text('High severity report'),
              subtitle: Text('2 minutes ago'),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('System update completed'),
              subtitle: Text('1 hour ago'),
            ),
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

  void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Admin Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 40, color: Colors.blue[700]),
            ),
            SizedBox(height: 16),
            Text('Admin User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('admin@safespeak.com',
                style: TextStyle(color: Colors.grey[600])),
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
}

// Dashboard Tab
class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(detectionStatsProvider);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(context, stats, isDesktop),
          SizedBox(height: 20),
          _buildRecentActivity(context, ref),
          SizedBox(height: 20),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
      BuildContext context, DetectionStats stats, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard('Total Messages', stats.totalMessages.toString(),
            Icons.message, Colors.blue),
        _buildStatCard('Toxic Detected', stats.toxicMessages.toString(),
            Icons.warning, Colors.red),
        _buildStatCard('Messages Blocked', stats.blockedMessages.toString(),
            Icons.block, Colors.orange),
        _buildStatCard('Reports Generated', stats.reportsGenerated.toString(),
            Icons.report, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ...reports
                .take(3)
                .map((report) => _buildActivityItem(report))
                .toList(),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.read(selectedTabProvider.notifier).state = 1,
              child: Text('View All Reports'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Report report) {
    Color severityColor;
    switch (report.severity) {
      case 'Critical':
        severityColor = Colors.red;
        break;
      case 'High':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.blue;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: severityColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.content,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  '${report.severity} • ${DateFormat.yMMMd().add_jm().format(report.timestamp)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildActionChip('Add User', Icons.person_add, Colors.blue),
                _buildActionChip(
                    'Export Reports', Icons.download, Colors.green),
                _buildActionChip(
                    'System Settings', Icons.settings, Colors.orange),
                _buildActionChip(
                    'Send Alert', Icons.notification_important, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon, Color color) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, color: color, size: 18),
      onPressed: () {},
    );
  }
}

// Reports Tab
class ReportsTab extends ConsumerWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showFilterDialog(context),
                icon: Icon(Icons.filter_list),
                label: Text('Filter'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return _buildReportCard(context, report);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    Color severityColor;
    switch (report.severity) {
      case 'Critical':
        severityColor = Colors.red;
        break;
      case 'High':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.blue;
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(report.severity),
                  backgroundColor: severityColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                      color: severityColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat.yMMMd().add_jm().format(report.timestamp),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(report.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Category: ${report.category}',
                style: TextStyle(color: Colors.grey[600])),
            Text('Reported by: ${report.reportedBy}',
                style: TextStyle(color: Colors.grey[600])),
            Text('Status: ${report.status}',
                style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _viewReportDetails(context, report),
                  child: Text('View Details'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _takeAction(context, report),
                  child: Text('Take Action'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Reports'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Severity'),
              items: ['All', 'Critical', 'High', 'Medium', 'Low']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Status'),
              items: ['All', 'Pending', 'Under Review', 'Resolved']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _viewReportDetails(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${report.id}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Content: ${report.content}'),
            SizedBox(height: 8),
            Text('Severity: ${report.severity}'),
            SizedBox(height: 8),
            Text('Category: ${report.category}'),
            SizedBox(height: 8),
            Text('Reported by: ${report.reportedBy}'),
            SizedBox(height: 8),
            Text('Status: ${report.status}'),
            SizedBox(height: 8),
            Text(
                'Timestamp: ${DateFormat.yMMMd().add_jm().format(report.timestamp)}'),
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

  void _takeAction(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Take Action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Mark as Resolved'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.person_off, color: Colors.red),
              title: Text('Suspend User'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title: Text('Issue Warning'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.escalator_warning, color: Colors.blue),
              title: Text('Escalate'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// Users Tab
class UsersTab extends ConsumerWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(context),
                icon: Icon(Icons.person_add),
                label: Text('Add User'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserCard(context, user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              user.status == 'Active' ? Colors.green[100] : Colors.red[100],
          child: Icon(
            Icons.person,
            color:
                user.status == 'Active' ? Colors.green[700] : Colors.red[700],
          ),
        ),
        title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text('${user.role} • ${user.reportCount} reports'),
            Text(
                'Last active: ${DateFormat.yMMMd().add_jm().format(user.lastActive)}'),
          ],
        ),
        trailing: Chip(
          label: Text(user.status),
          backgroundColor:
              user.status == 'Active' ? Colors.green[100] : Colors.red[100],
          labelStyle: TextStyle(
            color:
                user.status == 'Active' ? Colors.green[700] : Colors.red[700],
          ),
        ),
        onTap: () => _showUserDetails(context, user),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Role'),
              items: ['Student', 'Teacher', 'Admin']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: ${user.email}'),
            SizedBox(height: 8),
            Text('Role: ${user.role}'),
            SizedBox(height: 8),
            Text('Status: ${user.status}'),
            SizedBox(height: 8),
            Text('Report Count: ${user.reportCount}'),
            SizedBox(height: 8),
            Text(
                'Last Active: ${DateFormat.yMMMd().add_jm().format(user.lastActive)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (user.status == 'Active')
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Suspend', style: TextStyle(color: Colors.red)),
            ),
          if (user.status == 'Suspended')
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Activate', style: TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }
}

// Analytics Tab
class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToxicityChart(context),
          SizedBox(height: 20),
          _buildCategoryChart(context),
          SizedBox(height: 20),
          _buildTimeChart(context),
        ],
      ),
    );
  }

  Widget _buildToxicityChart(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toxicity Detection Rate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 5),
                        FlSpot(3, 3.5),
                        FlSpot(4, 4.8),
                        FlSpot(5, 6),
                        FlSpot(6, 4.2),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade700],
                      ),
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400.withOpacity(0.3),
                            Colors.blue.shade700.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.red.shade400,
                      title: 'Bullying\n40%',
                      titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.orange.shade400,
                      title: 'Harassment\n30%',
                      titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.blue.shade400,
                      title: 'Threats\n20%',
                      titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.green.shade400,
                      title: 'Other\n10%',
                      titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChart(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Messages Over Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1000,
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 800,
                          color: Colors.green.shade400,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: 50,
                          color: Colors.red.shade400,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 900,
                          color: Colors.green.shade400,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: 45,
                          color: Colors.red.shade400,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 750,
                          color: Colors.green.shade400,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: 60,
                          color: Colors.red.shade400,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.green.shade400, 'Safe Messages'),
                SizedBox(width: 20),
                _buildLegendItem(Colors.red.shade400, 'Toxic Messages'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Settings Tab
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetectionSettings(context),
          SizedBox(height: 20),
          _buildNotificationSettings(context),
          SizedBox(height: 20),
          _buildSystemSettings(context),
          SizedBox(height: 20),
          _buildLanguageSettings(context),
        ],
      ),
    );
  }

  Widget _buildDetectionSettings(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detection Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Real-time Detection'),
              subtitle: Text('Enable real-time message scanning'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Auto-block Toxic Messages'),
              subtitle: Text('Automatically block messages flagged as toxic'),
              value: true,
              onChanged: (value) {},
            ),
            ListTile(
              title: Text('Toxicity Threshold'),
              subtitle: Text('Sensitivity level for detection'),
              trailing: DropdownButton<String>(
                value: 'Medium',
                items: ['Low', 'Medium', 'High']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Parent Notifications'),
              subtitle: Text('Send notifications to parents/guardians'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Teacher Notifications'),
              subtitle: Text('Send notifications to teachers/counselors'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Email Alerts'),
              subtitle: Text('Send email alerts for critical incidents'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('SMS Alerts'),
              subtitle: Text('Send SMS alerts for urgent situations'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemSettings(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ListTile(
              title: Text('Data Retention'),
              subtitle: Text('How long to keep report data'),
              trailing: DropdownButton<String>(
                value: '1 Year',
                items: ['30 Days', '6 Months', '1 Year', '2 Years']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text('Backup Frequency'),
              subtitle: Text('How often to backup data'),
              trailing: DropdownButton<String>(
                value: 'Daily',
                items: ['Daily', 'Weekly', 'Monthly']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ),
            SwitchListTile(
              title: Text('Anonymous Reporting'),
              subtitle: Text('Allow users to report anonymously'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Debug Mode'),
              subtitle: Text('Enable detailed logging for troubleshooting'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSettings(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Language & Region',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ListTile(
              title: Text('Primary Language'),
              subtitle: Text('Main language for the system'),
              trailing: DropdownButton<String>(
                value: 'English',
                items: ['English', 'Spanish', 'French', 'German', 'Hindi']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ),
            SwitchListTile(
              title: Text('Multi-language Support'),
              subtitle: Text('Enable detection in multiple languages'),
              value: true,
              onChanged: (value) {},
            ),
            ListTile(
              title: Text('Time Zone'),
              subtitle: Text('System time zone'),
              trailing: DropdownButton<String>(
                value: 'UTC',
                items: ['UTC', 'EST', 'PST', 'GMT', 'IST']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {},
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _showConfirmDialog(context, 'Save Settings'),
                    child: Text('Save Settings'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _showConfirmDialog(context, 'Reset to Default'),
                    child: Text('Reset to Default'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Action'),
        content: Text('Are you sure you want to $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$action completed successfully')),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
