import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Services/ApiHandler.dart';
import 'package:safespeak/Services/SessionManagement.dart';
import 'package:safespeak/Services/api_service.dart';
import 'package:safespeak/Utils/LoginHelper.dart';

/// ---------------------------------------------------------------------------
/// 0.  LOW‑LEVEL PROVIDERS (put in providers.dart if you like)
/// ---------------------------------------------------------------------------
final loginHelperProvider = Provider<LoginHelper>((_) => LoginHelper());
final sessionMgmtProvider =
    Provider<SessionManagement>((_) => SessionManagement());

final apiHandlerProvider = Provider<ApiHandler>((ref) {
  return ApiHandler(
    ref.read(loginHelperProvider),
    ref.read(sessionMgmtProvider),
  );
});

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(ref.read(apiHandlerProvider)),
);
