import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:safespeak/Providers/ReportProvider.dart';

// Main screen widget
class ReportIncidentScreen extends ConsumerWidget {
  const ReportIncidentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Report Incident',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: const ResponsiveReportForm(),
    );
  }
}

// Responsive form widget
class ResponsiveReportForm extends ConsumerWidget {
  const ResponsiveReportForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportStateProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine if we should use tablet/desktop layout
    final isTablet = screenWidth > 600;
    final maxWidth = isTablet ? 800.0 : double.infinity;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.all(isTablet ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header text
              Text(
                'Please provide details about the cyberbullying incident. Your report will be reviewed by our team, and you can choose to remain anonymous.',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: isTablet ? 40 : 32),

              // Incident description
              const IncidentDescriptionField(),
              SizedBox(height: isTablet ? 32 : 24),

              // Users involved
              const UsersInvolvedField(),
              SizedBox(height: isTablet ? 32 : 24),

              // Date and time
              const DateTimeSection(),
              SizedBox(height: isTablet ? 32 : 24),

              // Attachments
              const AttachmentsSection(),
              SizedBox(height: isTablet ? 32 : 24),

              // Anonymous checkbox
              const AnonymousCheckbox(),
              SizedBox(height: isTablet ? 48 : 40),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: isTablet ? 60 : 56,
                child: ElevatedButton(
                  onPressed: reportState.isSubmitting
                      ? null
                      : () {
                          ref.read(reportStateProvider.notifier).submitReport();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40C4FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: reportState.isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Submit Report',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom text field widget
class CustomTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final Function(String) onChanged;
  final String value;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.value,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        onChanged: onChanged,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: isTablet ? 16 : 14,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: isTablet ? 16 : 14,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
        ),
      ),
    );
  }
}

// Incident description field
class IncidentDescriptionField extends ConsumerWidget {
  const IncidentDescriptionField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportStateProvider);

    return CustomTextField(
      hintText: 'Describe the incident in detail...',
      maxLines: 6,
      value: reportState.incidentDescription,
      onChanged: (value) {
        ref.read(reportStateProvider.notifier).updateIncidentDescription(value);
      },
    );
  }
}

// Users involved field
class UsersInvolvedField extends ConsumerWidget {
  const UsersInvolvedField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportStateProvider);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User(s) Involved (Optional)',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        CustomTextField(
          hintText: 'Enter usernames or identifiers...',
          value: reportState.usersInvolved,
          onChanged: (value) {
            ref.read(reportStateProvider.notifier).updateUsersInvolved(value);
          },
        ),
      ],
    );
  }
}

// Date and time section
class DateTimeSection extends ConsumerWidget {
  const DateTimeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportStateProvider);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date and Time of Incident',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: reportState.incidentDate ?? DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    ref
                        .read(reportStateProvider.notifier)
                        .updateIncidentDate(date);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.grey[600], size: isTablet ? 20 : 18),
                      SizedBox(width: isTablet ? 12 : 8),
                      Text(
                        reportState.incidentDate != null
                            ? '${reportState.incidentDate!.day}/${reportState.incidentDate!.month}/${reportState.incidentDate!.year}'
                            : 'Select Date',
                        style: TextStyle(
                          color: reportState.incidentDate != null
                              ? Colors.black87
                              : Colors.grey[600],
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: reportState.incidentTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    ref
                        .read(reportStateProvider.notifier)
                        .updateIncidentTime(time);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time,
                          color: Colors.grey[600], size: isTablet ? 20 : 18),
                      SizedBox(width: isTablet ? 12 : 8),
                      Text(
                        reportState.incidentTime != null
                            ? reportState.incidentTime!.format(context)
                            : 'Select Time',
                        style: TextStyle(
                          color: reportState.incidentTime != null
                              ? Colors.black87
                              : Colors.grey[600],
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Attachments section
class AttachmentsSection extends ConsumerWidget {
  const AttachmentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportStateProvider);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Include Screenshots or Evidence',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowMultiple: true,
                );
                if (result != null) {
                  for (final file in result.files) {
                    if (file.path != null) {
                      ref
                          .read(reportStateProvider.notifier)
                          .addAttachment(File(file.path!));
                    }
                  }
                }
              },
              icon: Icon(
                Icons.add,
                color: Colors.grey[700],
                size: isTablet ? 28 : 24,
              ),
            ),
          ],
        ),
        if (reportState.attachments.isNotEmpty) ...[
          SizedBox(height: isTablet ? 12 : 8),
          Wrap(
            spacing: isTablet ? 12 : 8,
            runSpacing: isTablet ? 12 : 8,
            children: reportState.attachments.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;

              return Container(
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image,
                        color: Colors.grey[600], size: isTablet ? 20 : 16),
                    SizedBox(width: isTablet ? 8 : 4),
                    Text(
                      file.path.split('/').last,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: isTablet ? 8 : 4),
                    GestureDetector(
                      onTap: () => ref
                          .read(reportStateProvider.notifier)
                          .removeAttachment(index),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: isTablet ? 18 : 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// Anonymous checkbox
class AnonymousCheckbox extends ConsumerWidget {
  const AnonymousCheckbox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportStateProvider);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GestureDetector(
      onTap: () => ref.read(reportStateProvider.notifier).toggleAnonymous(),
      child: Row(
        children: [
          Container(
            width: isTablet ? 24 : 20,
            height: isTablet ? 24 : 20,
            decoration: BoxDecoration(
              color: reportState.submitAnonymously
                  ? const Color(0xFF40C4FF)
                  : Colors.transparent,
              border: Border.all(
                color: reportState.submitAnonymously
                    ? const Color(0xFF40C4FF)
                    : Colors.grey[400]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: reportState.submitAnonymously
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: isTablet ? 16 : 14,
                  )
                : null,
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Text(
            'Submit Anonymously',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
