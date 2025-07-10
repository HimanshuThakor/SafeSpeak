import 'package:safespeak/Utils/SPHelper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginHelper {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String token = '';
  String? isLoggedIn;
  String? role;

  Future<void> getSecureData() async {
    token = await secureStorage.read(key: SPHelper.Token) ?? '';
    isLoggedIn = await secureStorage.read(key: SPHelper.isLoggedInKey);
  }

  String getToken() {
    return token;
  }

  String getIsLogin() {
    return isLoggedIn ?? '';
  }

  String getRole() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    String role = decodedToken['role'];
    return role ?? '';
  }

  Future<void> setToken(String value) async {
    await secureStorage.write(key: SPHelper.Token, value: value);
  }

  Future<void> setIsLogin(bool value) async {
    await secureStorage.write(
        key: SPHelper.isLoggedInKey, value: value.toString());
  }

  Future<void> clearToken() async {
    await secureStorage.delete(key: SPHelper.Token);
  }
}

// import 'package:LiveWell/utils/SPHelper.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LoginHelper {
//   SharedPreferences? prefs;
//   // int userId;
//   // int userType;
//   String token = '';
//   // String deviceDetail;
//   // String userName;
//   // String language;
//
//   Future getSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//     // userId = prefs.getInt('${SPHelper.UserId}');
//     // userType = prefs.getInt('${SPHelper.UserType}');
//     token = prefs!.getString(SPHelper.Token)!;
//     // deviceDetail = prefs.getString('${SPHelper.DeviceDetail}');
//     // userName = prefs.getString('${SPHelper.UserName}');
//     // language = prefs.getString('${SPHelper.Language}');
//   }
//
//   // int getCurrentPersonId() {
//   //   return userId;
//   // }
//
//   // int getCurrentUserType() {
//   //   return userType;
//   // }
//
//   String getToken() {
//     return token;
//   }
//
//   // String getDeviceDetail() {
//   //   return deviceDetail;
//   // }
//   //
//   // String getUserName() {
//   //   return userName;
//   // }
//   //
//   // String getLanguage() {
//   //   return language;
//   // }
// }
