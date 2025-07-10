import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/SosProvider.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class SOSScreen extends ConsumerStatefulWidget {
  const SOSScreen({super.key});

  @override
  ConsumerState<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends ConsumerState<SOSScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  bool _isSOSActivated = false;
  int _countdown = 0;
  bool _isCountdownActive = false;

  String? _base64Image; // Base64 encoded image string
  XFile? _selectedImageFile; // Actual selected image file

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCountdownActive = true;
      _countdown = 3;
    });

    _countdownTimer();
  }

  void _countdownTimer() {
    if (_countdown > 0) {
      Future.delayed(Duration(seconds: 1), () {
        if (_isCountdownActive) {
          setState(() {
            _countdown--;
          });
          _countdownTimer();
        }
      });
    } else {
      _activateSOS();
    }
  }

  void _cancelCountdown() {
    setState(() {
      _isCountdownActive = false;
      _countdown = 0;
    });
  }

  void _activateSOS() {
    setState(() {
      _isSOSActivated = true;
      _isCountdownActive = false;
    });

    // Haptic feedback
    HapticFeedback.heavyImpact();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SOS Alert Sent! Help is on the way.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isSOSActivated ? Colors.red[50] : Colors.grey[50],
      appBar: AppBar(
        title: Text('Emergency SOS'),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isWideScreen ? 32.0 : 16.0),
              child: Column(
                children: [
                  _buildHeader(isWideScreen),
                  SizedBox(height: 40),
                  _buildSOSButton(isWideScreen),
                  SizedBox(height: 40),
                  _buildQuickActions(isWideScreen),
                  SizedBox(height: 30),
                  _buildHelpResources(isWideScreen),
                  SizedBox(height: 30),
                  _buildEmergencyContacts(isWideScreen),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWideScreen) {
    return Column(
      children: [
        Icon(
          _isSOSActivated ? Icons.check_circle : Icons.warning_amber_rounded,
          size: isWideScreen ? 80 : 60,
          color: _isSOSActivated ? Colors.green : Colors.red[600],
        ),
        SizedBox(height: 16),
        Text(
          _isSOSActivated ? 'Help is Coming!' : 'Need Help?',
          style: TextStyle(
            fontSize: isWideScreen ? 28 : 24,
            fontWeight: FontWeight.bold,
            color: _isSOSActivated ? Colors.green : Colors.red[600],
          ),
        ),
        SizedBox(height: 8),
        Text(
          _isSOSActivated
              ? 'Your SOS alert has been sent to trusted contacts and support team.'
              : 'Tap the SOS button below to immediately alert your trusted contacts and our support team.',
          style: TextStyle(
            fontSize: isWideScreen ? 16 : 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSOSButton(bool isWideScreen) {
    return Column(
      children: [
        if (_isCountdownActive) ...[
          Text(
            'SOS Alert in',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$_countdown',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _cancelCountdown,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text('Cancel'),
          ),
        ] else ...[
          GestureDetector(
            onTap: _isSOSActivated ? null : _startCountdown,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isSOSActivated ? 1.0 : _pulseAnimation.value,
                  child: Container(
                    width: isWideScreen ? 200 : 160,
                    height: isWideScreen ? 200 : 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isSOSActivated ? Colors.green : Colors.red[600],
                      boxShadow: [
                        BoxShadow(
                          color: (_isSOSActivated ? Colors.green : Colors.red)
                              .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isSOSActivated ? Icons.check : Icons.warning,
                            size: isWideScreen ? 60 : 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text(
                            _isSOSActivated ? 'SENT' : 'SOS',
                            style: TextStyle(
                              fontSize: isWideScreen ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Text(
            _isSOSActivated
                ? 'Alert Successfully Sent'
                : 'Hold to Send SOS Alert',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions(bool isWideScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: isWideScreen ? 3 : 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: isWideScreen ? 1.2 : 1.0,
          children: [
            _buildActionCard(
              icon: Icons.block,
              title: 'Block User',
              subtitle: 'Block harmful user',
              color: Colors.orange,
              onTap: () => _showBlockUserDialog(),
            ),
            _buildActionCard(
              icon: Icons.report,
              title: 'Report',
              subtitle: 'Report cyberbullying',
              color: Colors.red,
              onTap: () => _showReportDialog(),
            ),
            _buildActionCard(
              icon: Icons.screenshot,
              title: 'Evidence',
              subtitle: 'Capture evidence',
              color: Colors.blue,
              onTap: () => _showEvidenceDialog(),
            ),
            _buildActionCard(
              icon: Icons.phone,
              title: 'Call Help',
              subtitle: 'Call helpline',
              color: Colors.green,
              onTap: () => _showCallHelpDialog(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpResources(bool isWideScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Help Resources',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        _buildResourceCard(
          icon: Icons.psychology,
          title: 'Mental Health Support',
          subtitle: 'Talk to a counselor',
          onTap: () => _showMentalHealthDialog(),
        ),
        SizedBox(height: 8),
        _buildResourceCard(
          icon: Icons.school,
          title: 'Educational Resources',
          subtitle: 'Learn about digital safety',
          onTap: () => _showEducationalDialog(),
        ),
        SizedBox(height: 8),
        _buildResourceCard(
          icon: Icons.group,
          title: 'Support Groups',
          subtitle: 'Connect with others',
          onTap: () => _showSupportGroupDialog(),
        ),
      ],
    );
  }

  Widget _buildResourceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(icon, color: Colors.blue[600]),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmergencyContacts(bool isWideScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contacts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildContactRow('Cyberbullying Helpline', '1-800-CYBER-HELP'),
                Divider(),
                _buildContactRow('National Suicide Prevention', '988'),
                Divider(),
                _buildContactRow('Crisis Text Line', 'Text HOME to 741741'),
                Divider(),
                _buildContactRow('Local Emergency', '911'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(String title, String contact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                contact,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.phone, color: Colors.green),
          onPressed: () => _makeCall(contact),
        ),
      ],
    );
  }

  // Dialog methods
  void _showBlockUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block User'),
        content: Text(
            'Are you sure you want to block this user? This will prevent them from contacting you.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessSnackBar('User blocked successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    // Reset the provider state when opening the dialog
    ref.read(reportDialogProvider.notifier).resetState();

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final reportState = ref.watch(reportDialogProvider);
          final reportNotifier = ref.read(reportDialogProvider.notifier);

          return AlertDialog(
            title: Text('Report Cyberbullying'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('What type of incident would you like to report?'),
                SizedBox(height: 16),
                ...ReportType.values.map((type) => RadioListTile<ReportType>(
                      title: Text(type.label),
                      value: type,
                      groupValue: reportState.selectedReportType,
                      onChanged: (ReportType? value) {
                        if (value != null) {
                          reportNotifier.selectReportType(value);
                        }
                      },
                    )),
                if (reportState.errorMessage != null) ...[
                  SizedBox(height: 16),
                  Text(
                    reportState.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: reportState.isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: reportState.isLoading
                    ? null
                    : () async {
                        await reportNotifier.submitReport();
                        if (reportState.selectedReportType != null &&
                            reportState.errorMessage == null) {
                          Navigator.of(context).pop();
                          _showSuccessSnackBar('Report submitted successfully');
                        }
                      },
                child: reportState.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Submit Report'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEvidenceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Capture Evidence'),
        content: Text(
          'Screenshots and messages are important evidence. Would you like to save current conversation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showImageSourceOptions();
            },
            child: Text('Save Evidence'),
          ),
        ],
      ),
    );
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = pickedFile;
      });

      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });

      _showSuccessSnackBar('Evidence captured and saved');
    } else {
      _showSuccessSnackBar('No image selected');
    }
  }

  void _showCallHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call Helpline'),
        content: Text('Would you like to call the Cyberbullying Helpline now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _makeCall('1-800-CYBER-HELP');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showMentalHealthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mental Health Support'),
        content: Text(
            'Connect with licensed counselors who specialize in cyberbullying and online harassment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessSnackBar('Connecting you with a counselor...');
            },
            child: Text('Connect Now'),
          ),
        ],
      ),
    );
  }

  void _showEducationalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Educational Resources'),
        content: Text(
            'Access guides, articles, and videos about digital safety, privacy settings, and how to handle online harassment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessSnackBar('Opening educational resources...');
            },
            child: Text('Learn More'),
          ),
        ],
      ),
    );
  }

  void _showSupportGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Support Groups'),
        content: Text(
            'Join safe, moderated support groups where you can share experiences and get support from others.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessSnackBar('Finding support groups near you...');
            },
            child: Text('Join Group'),
          ),
        ],
      ),
    );
  }

  void _makeCall(String number) {
    _showSuccessSnackBar('Calling $number...');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
