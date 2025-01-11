import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Facebook Login Page
class FacebookLoginPage extends StatefulWidget {
  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  Map<String, dynamic>? _userData;
  bool _isLoggedIn = false;

  // Facebook login method
  _login() async {
    final LoginResult result = await FacebookAuth.i.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      setState(() {
        _isLoggedIn = true;
        _userData = userData;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
      print('Facebook login failed: ${result.status}');
    }
  }

  // Facebook logout method
  _logout() async {
    await FacebookAuth.i.logOut();
    setState(() {
      _isLoggedIn = false;
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facebook Login Test'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoggedIn
                ? Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_userData!['picture']['data']['url']),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Logged in as ${_userData!['name']}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text('Email: ${_userData!['email']}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _logout,
                        child: Text('Logout'),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Login with Facebook'),
                      ),
                      SizedBox(height: 20),
                      Text('Not logged in yet'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// Entry point for testing Facebook login
void main() {
  runApp(MaterialApp(
    home: FacebookLoginPage(), // Directly open the Facebook Login Page
    debugShowCheckedModeBanner: false,
  ));
}
