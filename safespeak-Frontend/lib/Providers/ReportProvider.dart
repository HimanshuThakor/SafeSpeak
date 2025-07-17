import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

// State classes
class ReportState {
  final String incidentDescription;
  final String usersInvolved;
  final DateTime? incidentDate;
  final TimeOfDay? incidentTime;
  final List<File> attachments;
  final bool submitAnonymously;
  final bool isSubmitting;

  const ReportState({
    this.incidentDescription = '',
    this.usersInvolved = '',
    this.incidentDate,
    this.incidentTime,
    this.attachments = const [],
    this.submitAnonymously = false,
    this.isSubmitting = false,
  });

  ReportState copyWith({
    String? incidentDescription,
    String? usersInvolved,
    DateTime? incidentDate,
    TimeOfDay? incidentTime,
    List<File>? attachments,
    bool? submitAnonymously,
    bool? isSubmitting,
  }) {
    return ReportState(
      incidentDescription: incidentDescription ?? this.incidentDescription,
      usersInvolved: usersInvolved ?? this.usersInvolved,
      incidentDate: incidentDate ?? this.incidentDate,
      incidentTime: incidentTime ?? this.incidentTime,
      attachments: attachments ?? this.attachments,
      submitAnonymously: submitAnonymously ?? this.submitAnonymously,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ReportNotifier extends StateNotifier<ReportState> {
  ReportNotifier() : super(const ReportState());

  void updateIncidentDescription(String description) {
    state = state.copyWith(incidentDescription: description);
  }

  void updateUsersInvolved(String users) {
    state = state.copyWith(usersInvolved: users);
  }

  void updateIncidentDate(DateTime date) {
    state = state.copyWith(incidentDate: date);
  }

  void updateIncidentTime(TimeOfDay time) {
    state = state.copyWith(incidentTime: time);
  }

  void toggleAnonymous() {
    state = state.copyWith(submitAnonymously: !state.submitAnonymously);
  }

  void addAttachment(File file) {
    final updatedAttachments = [...state.attachments, file];
    state = state.copyWith(attachments: updatedAttachments);
  }

  void removeAttachment(int index) {
    final updatedAttachments = [...state.attachments];
    updatedAttachments.removeAt(index);
    state = state.copyWith(attachments: updatedAttachments);
  }

  Future<void> submitReport() async {
    state = state.copyWith(isSubmitting: true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Reset form after submission
    state = const ReportState();
  }
}

// Riverpod providers
final reportStateProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  return ReportNotifier();
});
