import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/ToxicityProvider.dart';
import 'package:safespeak/models/ToxicityResponseModel.dart';

class ToxicityScreen extends ConsumerStatefulWidget {
  const ToxicityScreen({super.key});

  @override
  ConsumerState<ToxicityScreen> createState() => _SafeSpeakScreenState();
}

class _SafeSpeakScreenState extends ConsumerState<ToxicityScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _checkMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      ref.read(checkStateProvider.notifier).checkMessage(message);
    }
  }

  void _showResultDialog(ToxicityResponse response) {
    showDialog(
      context: context,
      builder: (context) => ResultDialog(response: response),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkState = ref.watch(checkStateProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

    // Show dialog when response is available
    ref.listen<CheckState>(checkStateProvider, (previous, current) {
      if (current.response != null && previous?.response != current.response) {
        _showResultDialog(current.response!);
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isWeb ? 40 : 20),
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(isWeb ? 40 : 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 30),
                        _buildMessageInput(isWeb),
                        SizedBox(height: 20),
                        _buildSubmitButton(checkState.isLoading),
                        if (checkState.error != null) ...[
                          SizedBox(height: 20),
                          _buildErrorMessage(checkState.error!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          '🔐',
          style: TextStyle(fontSize: 48),
        ).animate().scale(duration: 600.ms),
        SizedBox(height: 10),
        Text(
          'SafeSpeak',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2c3e50),
          ),
        ).animate().fadeIn(delay: 200.ms),
        SizedBox(height: 8),
        Text(
          'Check your message for toxicity',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7f8c8d),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildMessageInput(bool isWeb) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _messageController,
        focusNode: _focusNode,
        maxLines: isWeb ? 4 : 3,
        decoration: InputDecoration(
          hintText: 'Type your message here...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
        onSubmitted: (_) => _checkMessage(),
      ),
    ).animate().slideX(delay: 600.ms);
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _checkMessage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4facfe),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Check Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    ).animate().scale(delay: 800.ms);
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red.shade600, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    ).animate().shake();
  }
}

// Result Dialog
class ResultDialog extends StatelessWidget {
  final ToxicityResponse response;

  const ResultDialog({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final isToxic = response.toxic;
    final score = response.score;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon and Status
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isToxic ? Colors.red.shade50 : Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isToxic ? Icons.warning : Icons.check_circle,
                size: 48,
                color: isToxic ? Colors.red : Colors.green,
              ),
            ).animate().scale(duration: 500.ms),

            SizedBox(height: 16),

            // Title
            Text(
              isToxic ? 'Toxic Content Detected' : 'Safe Message',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isToxic ? Colors.red.shade700 : Colors.green.shade700,
              ),
            ).animate().fadeIn(delay: 200.ms),

            SizedBox(height: 12),

            // Score
            Text(
              'Toxicity Score: ${(score * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ).animate().fadeIn(delay: 400.ms),

            SizedBox(height: 20),

            // Progress Bar
            LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isToxic ? Colors.red : Colors.green,
              ),
            ).animate().scaleX(delay: 600.ms),

            SizedBox(height: 20),

            // Message
            Text(
              isToxic
                  ? 'This message contains potentially harmful content. Please consider revising it.'
                  : 'This message appears to be safe and respectful.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ).animate().fadeIn(delay: 800.ms),

            SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                if (isToxic) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showReportDialog(context);
                      },
                      icon: Icon(Icons.report, size: 18),
                      label: Text('Report'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4facfe),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ).animate().slideY(delay: 1000.ms),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Submitted'),
        content: Text(
            'Thank you for reporting this content. Our team will review it shortly.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
