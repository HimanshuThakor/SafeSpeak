import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/AuthProvider.dart';
import 'package:safespeak/view/Dashboard/AdminDashboard.dart';
import 'package:safespeak/view/bottom_navigation/SafeSpeakBottomNav.dart';

// Assuming AuthNotifier and authProvider are already defined

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

  String _selectedUserType = 'Student';
  final List<String> _userTypes = ['Student', 'Parent', 'Teacher', 'NGO'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 800;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isWideScreen ? 32.0 : 16.0),
                child: Container(
                  width: isWideScreen ? 400 : double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(isWideScreen),
                      SizedBox(height: 40),
                      _buildAuthCard(isWideScreen, authState.isLoading),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWideScreen) {
    return Column(
      children: [
        Container(
          width: isWideScreen ? 80 : 60,
          height: isWideScreen ? 80 : 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield_outlined,
            color: Colors.white,
            size: isWideScreen ? 40 : 30,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'SafeSpeak',
          style: TextStyle(
            fontSize: isWideScreen ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Empowering Digital Safety Against Cyberbullying',
          style: TextStyle(
            fontSize: isWideScreen ? 16 : 14,
            color: Color(0xFF7F8C8D),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthCard(bool isWideScreen, bool isLoading) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(isWideScreen ? 32 : 24),
        child: Column(
          children: [
            _buildTabBar(),
            SizedBox(height: 24),
            _buildTabBarView(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF4A90E2),
        ),
        indicatorPadding: EdgeInsets.all(0),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFF7F8C8D),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Container(
            height: 45,
            alignment: Alignment.center,
            child: Text('Sign In'),
          ),
          Container(
            height: 45,
            alignment: Alignment.center,
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView(bool isLoading) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 300,
            maxHeight:
                constraints.maxHeight > 600 ? 600 : constraints.maxHeight * 0.8,
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: _buildSignInForm(isLoading),
              ),
              SingleChildScrollView(
                child: _buildSignUpForm(isLoading),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignInForm(bool isLoading) {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _signInEmailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _signInPasswordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: _validatePassword,
          ),
          SizedBox(height: 24),
          _buildActionButton(
            text: 'Sign In',
            onPressed: () => _handleSignIn(isLoading),
            isLoading: isLoading,
          ),
          // SizedBox(height: 16),
          // _buildForgotPasswordLink(),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: _handleForgotPassword,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF4A90E2),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF4A90E2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE1E5E9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE1E5E9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Color(0xFFFAFBFC),
      ),
    );
  }

  Widget _buildSignUpForm(bool isLoading) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _signUpNameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: _validateName,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _signUpEmailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          SizedBox(height: 16),
          _buildUserTypeDropdown(),
          SizedBox(height: 16),
          _buildTextField(
            controller: _signUpPasswordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: _validatePassword,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _signUpConfirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: _validateConfirmPassword,
          ),
          SizedBox(height: 24),
          _buildActionButton(
            text: 'Sign Up',
            onPressed: () => _handleSignUp(isLoading),
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedUserType,
      decoration: InputDecoration(
        labelText: 'I am a...',
        prefixIcon: Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE1E5E9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE1E5E9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        filled: true,
        fillColor: Color(0xFFFAFBFC),
      ),
      items: _userTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedUserType = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your user type';
        }
        return null;
      },
    );
  }

  // Validation functions
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _signUpPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Forgot Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your email address to reset your password.'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset link sent to your email.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  void _handleSignIn(bool isLoading) async {
    if (_signInFormKey.currentState!.validate()) {
      ref.read(authProvider.notifier).state =
          ref.read(authProvider).copyWith(isLoading: true);
      print("Email: ${_signInEmailController.text}");
      print("Password: ${_signInPasswordController.text}");

      await Future.delayed(Duration(seconds: 2));

      ref.read(authProvider.notifier).state =
          ref.read(authProvider).copyWith(isLoading: false);
      if (_signInEmailController.text == "admin@gmail.com" &&
          _signInPasswordController.text == "admin1234") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminDashboard(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SafeSpeakApp(),
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in successful! Welcome to SafeSpeak.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleSignUp(bool isLoading) async {
    if (_signUpFormKey.currentState!.validate()) {
      ref.read(authProvider.notifier).state =
          ref.read(authProvider).copyWith(isLoading: true);

      await Future.delayed(Duration(seconds: 2));

      ref.read(authProvider.notifier).state =
          ref.read(authProvider).copyWith(isLoading: false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully! Welcome to SafeSpeak.'),
          backgroundColor: Colors.green,
        ),
      );

      // _navigateToMainApp();
    }
  }

// void _navigateToMainApp() {
//   Navigator.of(context).pushReplacement(
//     MaterialPageRoute(
//       builder: (context) => MainAppScreen(userType: _selectedUserType),
//     ),
//   );
// }
}
