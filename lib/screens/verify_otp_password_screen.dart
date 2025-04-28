import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOTPForgotPasswordScreen extends StatefulWidget {
  const VerifyOTPForgotPasswordScreen({super.key});

  @override
  State<VerifyOTPForgotPasswordScreen> createState() =>
      _VerifyOTPForgotPasswordScreenState();
}

class _VerifyOTPForgotPasswordScreenState
    extends State<VerifyOTPForgotPasswordScreen> {
  List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final _focusNodes = List.generate(6, (index) => FocusNode());

  Future<void> _verifyOTP(String email) async {
    final otp = _controllers.map((c) => c.text).join();

    var response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/verify-reset-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'resetCode': otp}),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(
        context,
        '/reset-password',
        arguments: {'email': email, 'resetCode': otp},
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP is incorrect')));
    }
  }

  void _onOtpChanged(int index, String value, String email) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOTP(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Enter the 6-digit OTP sent to $email'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _onOtpChanged(index, value, email),
                    decoration: const InputDecoration(counterText: ''),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
