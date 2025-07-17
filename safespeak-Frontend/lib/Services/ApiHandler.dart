// lib/service/api_handler.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safespeak/Services/SessionManagement.dart';
import 'package:safespeak/Utils/ApiHelper.dart';
import 'package:safespeak/Utils/LoginHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHandler {
  ApiHandler(this._loginHelper, this._session);

  final LoginHelper _loginHelper;
  final SessionManagement _session;

  /* ─────────────────────────────── GET ─────────────────────────────── */
  Future<Map<String, dynamic>> getRequest(String endpoint) async {
    await _loginHelper.getSecureData();
    final url = Uri.parse('${ApiHelper.baseUrl}$endpoint');
    try {
      final response = await http.get(url, headers: _defaultHeaders());
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': 'An error occurred: $e'};
    }
  }

  /* ─────────────────────────────── POST ────────────────────────────── */
  Future<Map<String, dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    bool isLogin = false,
  }) async {
    if (!isLogin) await _loginHelper.getSecureData(); // refresh token if needed
    final url = Uri.parse('${ApiHelper.baseUrl}$endpoint');
    print('URL: $url');
    print('Body: $body');
    print("TOKEN: ${_loginHelper.getToken()}");
    print(isLogin ? _loginHeaders() : _defaultHeaders());

    try {
      final response = await http.post(
        url,
        headers: isLogin ? _loginHeaders() : _defaultHeaders(),
        body: jsonEncode(body),
      );
      print('Response: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': 'An error occurred: $e'};
    }
  }

  /* ─────────────────────────── Helpers ─────────────────────────────── */
  Map<String, String> _loginHeaders() =>
      {'content-type': 'application/json; charset=utf-8'};

  Map<String, String> _defaultHeaders() => {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${_loginHelper.getToken()}",
      };

  Map<String, dynamic> _handleResponse(http.Response r) {
    final data = jsonDecode(r.body);

    switch (data['status']) {
      case 200:
      case 201:
        return data;
      case 401:
      case 402:
      case 403:
      case 503:
        _clearSession(); // only clear –no navigation here
        return {...data, 'forceLogout': true};
      default:
        return data;
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _session.clearLocalStorage();
    _session.destroyMap();
  }
}
