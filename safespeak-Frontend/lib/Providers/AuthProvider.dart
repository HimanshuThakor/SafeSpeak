import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final User? user;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
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
    // Listen to auth state changes
    _authStateSubscription = _firebaseAuth.authStateChanges().listen((user) {
      // Only set authenticated state if we have both Firebase user and valid API session
      if (user != null) {
        _checkApiSession();
      } else {
        state = state.copyWith(
          user: null,
          isAuthenticated: false,
          isLoading: false,
        );
      }
    });
  }

  final Ref ref;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ApiService _api;
  final LoginHelper _loginHelper;
  final SessionManagement _session;

  late final StreamSubscription<User?> _authStateSubscription;

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  // Check if user has valid API session
  Future<void> _checkApiSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(SPHelper.Token);
      final isLoggedIn = await _loginHelper.getIsLogin();

      if (token != null && isLoggedIn == true) {
        state = state.copyWith(
          user: _firebaseAuth.currentUser,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          user: null,
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        user: null,
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name, String phone) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      String? token = await FirebaseMessaging.instance.getToken();

      // First, create user with Firebase
      final UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If Firebase signup is successful, call the API
      if (result.user != null) {
        try {
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

            // Send email verification
            if (!result.user!.emailVerified) {
              await result.user!.sendEmailVerification();
            }

            state = state.copyWith(
              isLoading: false,
              user: result.user,
              isAuthenticated: true,
            );
          } else {
            // If API call failed, delete the Firebase user and throw error
            await result.user!.delete();
            throw Exception('Failed to create account on server');
          }
        } catch (apiError) {
          // If API call failed, delete the Firebase user
          await result.user!.delete();
          throw apiError;
        }
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().contains('Failed to create account')
            ? 'Failed to create account on server'
            : 'An unexpected error occurred during signup',
      );
    }
  }

  // Sign in with email and password - Check API first, then Firebase
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // First check with API
      ResponseModel? response = await _api.login(
        ApiBodyJson(
          email: email,
          password: password,
        ),
      );

      if (response != null && response.data != null) {
        // API login successful, now sign in with Firebase
        try {
          final UserCredential result =
              await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (result.user != null && !result.user!.emailVerified) {
            await result.user!.sendEmailVerification();
            signUpWithEmailAndPassword(email, password, '', '');
          }

          // Save login data from API response
          LogInModel login = LogInModel.fromJson(response.data);
          final prefs = await SharedPreferences.getInstance();
          await _loginHelper.setToken(login.token ?? '');
          await prefs.setString(SPHelper.Token, login.token ?? '');
          await _loginHelper.setIsLogin(true);
          await _session.createSessionMap(login);

          state = state.copyWith(
            isLoading: false,
            user: result.user,
            isAuthenticated: true,
          );
        } on FirebaseAuthException catch (e) {
          // If Firebase login fails after API success, clear the API session
          await _clearUserSession();
          throw e;
        }
      } else {
        // API login failed
        throw Exception('Invalid credentials or user not found');
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().contains('Invalid credentials')
            ? 'Invalid email or password'
            : 'Login failed. Please try again.',
      );
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      // state = state.copyWith(isLoading: true, error: null);
      //
      // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // if (googleUser == null) {
      //   state = state.copyWith(isLoading: false);
      //   return;
      // }
      //
      // final GoogleSignInAuthentication googleAuth =
      //     await googleUser.authentication;
      //
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.idToken,
      //   idToken: googleAuth.idToken,
      // );
      //
      // final UserCredential result =
      //     await _firebaseAuth.signInWithCredential(credential);
      //
      // state = state.copyWith(
      //   isLoading: false,
      //   user: result.user,
      //   isAuthenticated: true,
      // );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
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

      await _firebaseAuth.signOut();
      await _clearUserSession();

      state = state.copyWith(
        isLoading: false,
        user: null,
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

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
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

  // Get user-friendly error messages
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }
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
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});
