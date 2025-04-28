import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword(String email, String resetCode) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    var response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/reset-password-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'resetCode': resetCode,
        'newPassword': _passwordController.text,
        'confirmPassword': _passwordController.text,
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to reset password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final email = args['email'];
    final resetCode = args['resetCode'];

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Enter your new password'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () => _resetPassword(email!, resetCode!),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
