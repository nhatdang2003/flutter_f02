import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/verify_otp_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/verify-otp': (context) => VerifyOTPScreen(),
        '/login': (context) => LoginScreen(),
      },
    ),
  );
}
