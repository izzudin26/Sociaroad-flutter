import 'dart:async';
import 'package:flutter/material.dart';
import 'package:society_road/navigation.dart';
import 'package:society_road/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:society_road/webservice/authService.dart';
import 'package:society_road/widget/snackbarAlert.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isShowForm = false;
  bool isShowPassword = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/navigation');
      } else {
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            isShowForm = true;
          });
        });
      }
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                width:
                    MediaQuery.of(context).size.width * (isShowForm ? .5 : .7),
                duration: Duration(milliseconds: 1000),
                child: Lottie.asset('assets/login.json'),
              ),
              AnimatedSize(
                vsync: this,
                duration: Duration(seconds: 1),
                child: Visibility(
                  visible: isShowForm,
                  child: Container(
                    height: isShowForm ? null : 0,
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: password,
                          obscureText: !isShowPassword ? true : false,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isShowPassword = !isShowPassword;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: isShowPassword
                                        ? Colors.blue
                                        : Colors.black26,
                                  )),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Belum memiliki akun?",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextButton(
                                onPressed: () async {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Registration()));
                                },
                                child: Text("Daftar"))
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              try {
                                await AuthService.login(
                                    email: email.text, password: password.text);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NavigationApp()));
                              } catch (e) {
                                showSnackbar(context, e.toString());
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(child: Text("Login")),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
