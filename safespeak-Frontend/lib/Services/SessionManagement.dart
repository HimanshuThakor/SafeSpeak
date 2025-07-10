import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safespeak/models/LogInModel.dart';

class SessionManagement {
  static const _storage = FlutterSecureStorage();
  static const _mapKey = 'MAP';

  Future<void> createSessionMap(LogInModel login) async {
    await saveModelMap(_mapKey, login);
  }

  Future<void> saveModelMap(String key, LogInModel mapping) async {
    final jsonStr = json.encode(mapping);
    await _storage.write(key: key, value: jsonStr);
  }

  Future<LogInModel?> getModel(String? key) async {
    final jsonStr = await _storage.read(key: key ?? _mapKey);
    if (jsonStr == null) return null;
    return LogInModel.fromJson(json.decode(jsonStr));
  }

  Future<void> destroyMap() async {
    await _storage.delete(key: _mapKey);
  }

  Future<void> clearLocalStorage() async {
    await _storage.deleteAll();
  }
}
