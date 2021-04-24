import 'package:flutter/material.dart';
import 'package:movies_clone/models/user_model.dart';
import 'package:movies_clone/providers/auth_providers.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style: TextStyle(
                          color: Color.fromARGB(250, 13, 8, 66), fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "WatchMe",
                      style: TextStyle(
                          color: Color.fromARGB(250, 13, 8, 66),
                          fontWeight: FontWeight.w600,
                          fontSize: 45),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(120, 13, 8, 66)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            focusColor: Color.fromARGB(10, 13, 8, 66),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(120, 13, 8, 66)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            focusColor: Color.fromARGB(10, 13, 8, 66),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 13, 8, 66),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Divider(
                        color: Color.fromARGB(255, 13, 8, 66),
                        indent: 50,
                        endIndent: 50,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Color.fromARGB(255, 13, 8, 66),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("OR"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Color.fromARGB(255, 13, 8, 66),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Text(
                            "Login anonymously",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onPressed: () async {
                            UserModel user = await AuthProvider().signInAnon();
                            print(user.uid);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
