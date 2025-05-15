import 'package:flutter/material.dart';
import 'package:homework8_mobile5_rabbitmq/pages/home_page.dart';
import 'package:homework8_mobile5_rabbitmq/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

String? currentUser;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');

    if (savedUsername == null) return false;

    final res = await http.get(
      Uri.parse('http://192.168.0.105:5182/Auth/$savedUsername'),
    );
    if (res.statusCode == 200) {
      currentUser = savedUsername;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RabbitMQ Auth Demo',
      home: FutureBuilder(
        future: _checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data == true) {
            return HomePage(username: currentUser!);
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
