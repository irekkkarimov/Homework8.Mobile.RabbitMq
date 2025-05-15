import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homework8_mobile5_rabbitmq/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  String? error;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    final response = await http.post(
      Uri.parse('http://192.168.0.105:5182/Auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    print(response);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomePage(username: username)),
      );
    } else {
      setState(() {
        error = 'Login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}