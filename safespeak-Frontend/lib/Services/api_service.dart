// lib/service/api_service.dart
import 'package:safespeak/Services/ApiHandler.dart';
import 'package:safespeak/Utils/ApiHelper.dart';
import 'package:safespeak/models/ApiJsonBodyRequest.dart';
import 'package:safespeak/models/ResponseModel.dart';

class ApiService {
  ApiService(this._handler);

  final ApiHandler _handler;

  /* ───────── Common helper ───────── */
  Future<ResponseModel?> _post(
    String endpoint,
    Map<String, dynamic> body, {
    bool isLogin = false,
  }) async {
    try {
      final json = await _handler.postRequest(endpoint, body, isLogin: isLogin);
      return ResponseModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> _get(String endpoint) async {
    try {
      final json = await _handler.getRequest(endpoint);
      return ResponseModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel?> login(ApiBodyJson body) =>
      _post(ApiHelper.loginUrl, body.toJson(), isLogin: true);

  Future<ResponseModel?> signup(ApiBodyJson body) =>
      _post(ApiHelper.registerUrl, body.toJson(), isLogin: true);

  Future<ResponseModel?> checkMessage(ApiBodyJson body) =>
      _post(ApiHelper.checkMessage, body.toJson());

  Future<ResponseModel?> addFamilyMember(ApiBodyJson body) =>
      _post("${ApiHelper.addFamilyMember + '/${body.id}'}", body.toJson());

  Future<ResponseModel?> updateFamilyMember(ApiBodyJson body) =>
      _post("${ApiHelper.updateFamilyMember + '/${body.id}'}", body.toJson());

  Future<ResponseModel?> getFamilyMembers(ApiBodyJson body) =>
      _get("${ApiHelper.getFamilyMembers}/${body.id}");

  Future<ResponseModel?> removeFamilyMember(String id, String userid) =>
      _post("users/$userid/delete-emergency-contacts/$id", {});

  Future<ResponseModel?> submitSos(ApiBodyJson body) =>
      _post(ApiHelper.submitSos, body.toJson());

// // /* ───────── EVENTS ───────── */
// Future<ResponseModel?> fetchEvents() => _get(ApiHelper.getEvents);
//
// Future<ResponseModel?> fetchEventsForUser() =>
//     _get(ApiHelper.getEventsForUser);
//
// Future<ResponseModel?> createEvent(ApiBodyJson body) =>
//     _post(ApiHelper.createEvent, body.toJson());
//
// Future<ResponseModel?> updateEvent(ApiBodyJson body) =>
//     _post("${ApiHelper.createEvent + '/${body.id}'}", body.toJson());
//
// Future<ResponseModel?> deleteEvent(ApiBodyJson body) =>
//     _post("${ApiHelper.deleteEvent + '/${body.id}'}", {});
//
// Future<ResponseModel?> bookEvent(ApiBodyJson body) =>
//     _post(ApiHelper.bookEvent, body.toJson());
//
// // /* ───────── CATEGORY ───────── */
// Future<ResponseModel?> createCategory(ApiBodyJson body) =>
//     _post(ApiHelper.createCategory, body.toJson());
//
// Future<ResponseModel?> updateCategory(ApiBodyJson body) =>
//     _post("${ApiHelper.updateCategory + '/${body.id}'}", body.toJson());
//
// Future<ResponseModel?> fetchAllCategories() =>
//     _get(ApiHelper.getAllCategories);
//
// Future<ResponseModel?> deleteCategory(ApiBodyJson body) =>
//     _post("${ApiHelper.deleteCategory + '/${body.id}'}", {});
//
// // /* ───────── SCANNER ───────── */
// Future<ResponseModel?> getScanners() => _get(ApiHelper.getScanners);
//
// Future<ResponseModel?> createScanner(ApiBodyJson body) =>
//     _post(ApiHelper.createScanner, body.toJson());
//
// Future<ResponseModel?> updateScanner(ApiBodyJson body) =>
//     _post("${ApiHelper.updateScanner + '/${body.id}'}", body.toJson());
//
// Future<ResponseModel?> deleteScanner(ApiBodyJson body) =>
//     _post("${ApiHelper.deleteScanner + '/${body.id}'}", {});
//
// Future<ResponseModel?> assignEventToScanner(ApiBodyJson body) =>
//     _post(ApiHelper.assignEventToScanner, body.toJson());
//
// Future<ResponseModel?> fetchAssignedEvents(ApiBodyJson body) =>
//     _get("${ApiHelper.fetchAssignedEvents + '/${body.userId}'}");
//
// Future<ResponseModel?> checkTicketIsValid(ApiBodyJson body) =>
//     _post(ApiHelper.checkTicketIsValid, body.toJson());
//
// // /* ───────── Payment ───────── */
// Future<ResponseModel?> createPaymentOrder(ApiBodyJson body) =>
//     _post(ApiHelper.createPaymentOrder, body.toJson());
//
// // /* ───────── Auth ───────── */
// Future<ResponseModel?> login(ApiBodyJson json) => _post(
//       ApiHelper.loginUrl,
//       json.toJson(),
//       isLogin: true,
//     );
//
// Future<ResponseModel?> signUp(ApiBodyJson json) => _post(
//       ApiHelper.registerUrl,
//       json.toJson(),
//       isLogin: true,
//     );
//
// Future<ResponseModel?> getDashboardData() => _get(ApiHelper.getDashboardData);
//
// Future<ResponseModel?> profileUpdate(ApiBodyJson json) => _post(
//       ApiHelper.userProfile,
//       json.toJson(),
//     );
//
// Future<ResponseModel?> fetchUsersDetails() => _get(ApiHelper.getUsersDetails);

// Future<ResponseModel?> sendOtp(SignUpAuth signUpAuth) =>
//     _post(ApiHelper.signIn, signUpAuth.toJson(), isLogin: true);
//
// Future<ResponseModel?> verifyOtp(String userId, String otp) =>
//     _post(ApiHelper.verifyOtp, {'userId': userId, 'otp': otp}, isLogin: true);
//
// Future<ResponseModel?> verifyOtpOnSignIn(SignUpAuth signUpAuth) =>
//     _post(ApiHelper.verifyOtpWithMobileAndEmail, signUpAuth.toJson(),
//         isLogin: true);
//
// Future<ResponseModel?> resendOtp(String email) =>
//     _post(ApiHelper.resendOtp, {'emailId': email}, isLogin: true);
//
// Future<ResponseModel?> signInWithEmailPassword(SignUpAuth signUpAuth) =>
//     _post(
//       ApiHelper.signIn,
//       signUpAuth.toJson(),
//       isLogin: true,
//     );
//
// Future<ResponseModel?> signup(SignUpAuth signUpAuth) => _post(
//       ApiHelper.signup,
//       signUpAuth.toJson(),
//       isLogin: true,
//     );
//
// Future<ResponseModel?> logoutUser() => _post(ApiHelper.logout, const {});
//
// Future<ResponseModel?> getMemberDetails() =>
//     _post(ApiHelper.getMemberDetails, const {});
//
// Future<ResponseModel?> getTestMaster() =>
//     _post(ApiHelper.getTestMaster, const {});
}
