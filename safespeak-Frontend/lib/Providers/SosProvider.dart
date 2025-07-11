import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/ApiServiceProvider.dart';
import 'package:safespeak/Services/SessionManagement.dart';
import 'package:safespeak/Services/api_service.dart';
import 'package:safespeak/models/ApiJsonBodyRequest.dart';
import 'package:safespeak/models/ResponseModel.dart';

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
  ReportDialogNotifier(this.ref)
      : _api = ref.read(apiServiceProvider),
        _session = ref.read(sessionMgmtProvider),
        super(const ReportDialogState());
  final Ref ref;
  final ApiService _api;
  final SessionManagement _session;

  void selectReportType(ReportType reportType) {
    state = state.copyWith(selectedReportType: reportType);
  }

  void clearSelection() {
    state = state.copyWith(selectedReportType: null);
  }

  Future<void> submitSos() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      var loginResponse = await _session.getModel("MAP");
      String id = loginResponse!.user!.id;
      ResponseModel? response = await _api.submitSos(ApiBodyJson(
          userId: id, location: "123456", timestamp: DateTime.now()));
      if (response != null && response.success == true) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to submit SOS. Please try again.');
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to submit SOS. Please try again.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
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
  (ref) => ReportDialogNotifier(ref),
);
