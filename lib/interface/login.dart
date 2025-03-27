import 'package:flutter/material.dart';
import 'ResetPassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email or username",
                    filled: true,
                    fillColor: Colors.brown[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.brown[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Logging in..."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Log in",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.brown[800],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
