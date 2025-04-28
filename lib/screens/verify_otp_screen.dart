import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOTPScreen extends StatefulWidget {
  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isSubmitting = false;

  Future<void> _verifyOTP(String email) async {
    setState(() {
      _isSubmitting = true;
    });

    String otp = _controllers.map((e) => e.text).join();
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/activate-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'activationCode': otp}),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OTP không đúng')));
    }
  }

  void _onOtpChanged(String value, int index, String email) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      _verifyOTP(email);
    }
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Xác nhận OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nhập mã OTP gửi tới $email'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    decoration: InputDecoration(counterText: ''),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) => _onOtpChanged(value, index, email),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            if (_isSubmitting) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
