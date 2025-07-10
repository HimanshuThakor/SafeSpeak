import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum for report types
enum ReportType {
  harassment(1, 'Harassment'),
  threats(2, 'Threats'),
  inappropriateContent(3, 'Inappropriate Content');

  const ReportType(this.value, this.label);
  final int value;
  final String label;

  static ReportType? fromValue(int value) {
    switch (value) {
      case 1:
        return ReportType.harassment;
      case 2:
        return ReportType.threats;
      case 3:
        return ReportType.inappropriateContent;
      default:
        return null;
    }
  }
}

// State class for report dialog
class ReportDialogState {
  final ReportType? selectedReportType;
  final bool isLoading;
  final String? errorMessage;

  const ReportDialogState({
    this.selectedReportType,
    this.isLoading = false,
    this.errorMessage,
  });

  ReportDialogState copyWith({
    ReportType? selectedReportType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReportDialogState(
      selectedReportType: selectedReportType ?? this.selectedReportType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// StateNotifier for managing report dialog state
class ReportDialogNotifier extends StateNotifier<ReportDialogState> {
  ReportDialogNotifier() : super(const ReportDialogState());

  void selectReportType(ReportType reportType) {
    state = state.copyWith(selectedReportType: reportType);
  }

  void clearSelection() {
    state = state.copyWith(selectedReportType: null);
  }

  Future<void> submitReport() async {
    if (state.selectedReportType == null) {
      state = state.copyWith(errorMessage: 'Please select a report type');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically make an API call to submit the report
      // For now, we'll just simulate success

      // Reset state after successful submission
      state = const ReportDialogState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to submit report. Please try again.',
      );
    }
  }

  void resetState() {
    state = const ReportDialogState();
  }
}

// Provider for the report dialog
final reportDialogProvider =
    StateNotifierProvider<ReportDialogNotifier, ReportDialogState>(
  (ref) => ReportDialogNotifier(),
);
