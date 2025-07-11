import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/ApiServiceProvider.dart';
import 'package:safespeak/Services/SessionManagement.dart';
import 'package:safespeak/Services/api_service.dart';
import 'package:safespeak/Utils/LoginHelper.dart';
import 'package:safespeak/Utils/SPHelper.dart';
import 'package:safespeak/models/ApiJsonBodyRequest.dart';
import 'package:safespeak/models/LogInModel.dart';
import 'package:safespeak/models/RegisterUserModel.dart';
import 'package:safespeak/models/ResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoading;
  final String? userId;
  final String? email;
  final String? name;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.userId,
    this.email,
    this.name,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? userId,
    String? email,
    String? name,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref)
      : _api = ref.read(apiServiceProvider),
        _loginHelper = ref.read(loginHelperProvider),
        _session = ref.read(sessionMgmtProvider),
        super(AuthState()) {
    // Check authentication status on initialization
    _checkAuthStatus();
  }

  final Ref ref;
  final ApiService _api;
  final LoginHelper _loginHelper;
  final SessionManagement _session;

  // Check if user has valid API session
  Future<void> _checkAuthStatus() async {
    try {
      state = state.copyWith(isLoading: true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(SPHelper.Token);
      final isLoggedIn = await _loginHelper.getIsLogin();

      if (token != null && isLoggedIn == true) {
        // Get user info from session or API
        final userInfo = await _getUserInfo();

        state = state.copyWith(
          userId: userInfo['userId'],
          email: userInfo['email'],
          name: userInfo['name'],
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          userId: null,
          email: null,
          name: null,
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        userId: null,
        email: null,
        name: null,
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  // Get user info from local storage or API
  Future<Map<String, String?>> _getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'userId': prefs.getString('userId'),
        'email': prefs.getString('userEmail'),
        'name': prefs.getString('userName'),
      };
    } catch (e) {
      return {'userId': null, 'email': null, 'name': null};
    }
  }

  // Save user info to local storage
  Future<void> _saveUserInfo(
      String? userId, String? email, String? name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (userId != null) await prefs.setString('userId', userId);
      if (email != null) await prefs.setString('userEmail', email);
      if (name != null) await prefs.setString('userName', name);
    } catch (e) {
      // Handle error if needed
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name, String phone) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      String? token = await FirebaseMessaging.instance.getToken();

      // Call the API to create user
      ResponseModel? response = await _api.signup(
        ApiBodyJson(
            email: email,
            password: password,
            name: name,
            phone: phone,
            fcmToken: token),
      );

      // Check if API call was successful
      if (response != null && response.data != null) {
        RegisterUserModel registerUser =
            RegisterUserModel.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();

        // Save token and login status
        await _loginHelper.setToken(registerUser.token ?? '');
        await prefs.setString(SPHelper.Token, registerUser.token ?? '');
        await _loginHelper.setIsLogin(true);

        // Create session
        LogInModel logInModel = LogInModel.fromJson(response.data);
        await _session.createSessionMap(logInModel);

        // Save user info
        await _saveUserInfo(
          registerUser.user!.id ?? logInModel.user!.id,
          email,
          name,
        );

        state = state.copyWith(
          isLoading: false,
          userId: registerUser.user!.id ?? logInModel.user!.id,
          email: email,
          name: name,
          isAuthenticated: true,
        );
      } else {
        throw Exception('Failed to create account on server');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().contains('Failed to create account')
            ? 'Failed to create account on server'
            : 'An unexpected error occurred during signup',
      );
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      String? token = await FirebaseMessaging.instance.getToken();

      // Call API to login
      ResponseModel? response = await _api.login(
        ApiBodyJson(
          email: email,
          password: password,
          fcmToken: token,
        ),
      );

      if (response != null && response.data != null) {
        // Save login data from API response
        LogInModel login = LogInModel.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await _loginHelper.setToken(login.token ?? '');
        await prefs.setString(SPHelper.Token, login.token ?? '');
        await _loginHelper.setIsLogin(true);
        await _session.createSessionMap(login);

        // Save user info
        await _saveUserInfo(
          login.user!.id,
          email,
          login.user!.name,
        );

        state = state.copyWith(
          isLoading: false,
          userId: login.user!.id,
          email: email,
          name: login.user!.name,
          isAuthenticated: true,
        );
      } else {
        throw Exception('Invalid credentials or user not found');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().contains('Invalid credentials')
            ? 'Invalid email or password'
            : 'Login failed. Please try again.',
      );
    }
  }

  // Sign in with Google (placeholder - implement according to your needs)
  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Implement Google Sign In logic here
      // You might want to use google_sign_in package
      // and then call your API with the Google credentials

      state = state.copyWith(
        isLoading: false,
        error: 'Google Sign In not implemented',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  // Clear user session data
  Future<void> _clearUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SPHelper.Token);
      await prefs.remove('userId');
      await prefs.remove('userEmail');
      await prefs.remove('userName');
      await _loginHelper.setToken('');
      await _loginHelper.setIsLogin(false);
      await _session.clearLocalStorage();
    } catch (e) {
      // Handle error if needed
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _clearUserSession();

      state = state.copyWith(
        isLoading: false,
        userId: null,
        email: null,
        name: null,
        isAuthenticated: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to sign out',
      );
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Call your API to send password reset email
      // Replace this with your actual API call
      // ResponseModel? response = await _api.resetPassword(email);
      //
      // if (response != null && response.success == true) {
      //   state = state.copyWith(isLoading: false);
      // } else {
      //   throw Exception('Failed to send reset email');
      // }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send reset email',
      );
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  // Get current user info
  Map<String, String?> get currentUser => {
        'userId': state.userId,
        'email': state.email,
        'name': state.name,
      };
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Helper provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

// Helper provider to get current user
final currentUserProvider = Provider<Map<String, String?>>((ref) {
  final authState = ref.watch(authProvider);
  return {
    'userId': authState.userId,
    'email': authState.email,
    'name': authState.name,
  };
});
