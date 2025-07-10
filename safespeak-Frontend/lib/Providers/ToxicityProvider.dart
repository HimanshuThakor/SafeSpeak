import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/ApiServiceProvider.dart';
import 'package:safespeak/Services/api_service.dart';
import 'package:safespeak/models/ApiJsonBodyRequest.dart';
import 'package:safespeak/models/ResponseModel.dart';
import 'package:safespeak/models/ToxicityResponseModel.dart';

class CheckState {
  final bool isLoading;
  final ToxicityResponse? response;
  final String? error;

  CheckState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  CheckState copyWith({
    bool? isLoading,
    ToxicityResponse? response,
    String? error,
  }) {
    return CheckState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}

class CheckNotifier extends StateNotifier<CheckState> {
  final ApiService _apiService;

  CheckNotifier(this._apiService) : super(CheckState());

  Future<void> checkMessage(String message) async {
    if (message.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      ResponseModel? response =
          await _apiService.checkMessage(ApiBodyJson(message: message));

      if (response != null && response.data != null) {
        ToxicityResponse toxicityResponse =
            ToxicityResponse.fromJson(response.data);
        state = state.copyWith(
          isLoading: false,
          response: toxicityResponse,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = CheckState();
  }
}

final checkStateProvider =
    StateNotifierProvider<CheckNotifier, CheckState>((ref) {
  return CheckNotifier(ref.watch(apiServiceProvider));
});
