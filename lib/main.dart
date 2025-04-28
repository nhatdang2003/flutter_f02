import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/verify_otp_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forget_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/verify_otp_password_screen.dart';
import 'screens/home_screen.dart';
import 'utils/auth_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await AuthHelper.isLoggedIn();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
      routes: {
        '/forgot-password': (context) => const ForgetPasswordScreen(),
        '/verify-otp-forgot-password':
            (context) => const VerifyOTPForgotPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/register': (context) => RegistrationScreen(),
        '/verify-otp': (context) => VerifyOTPScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    ),
  );
}
