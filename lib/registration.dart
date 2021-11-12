import 'dart:async';

import 'package:flutter/material.dart';

import 'login.dart';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> with TickerProviderStateMixin {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController address = TextEditingController();

  bool isShowPassword = false;
  bool isShowConfirmPassword = false;

  bool isShowForm = false;

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 1), () {
      setState(() {
        isShowForm = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: MediaQuery.of(context).size.width * (isShowForm ? .5 : .7),
              duration: Duration(milliseconds: 1000),
              child: Image.asset("assets/lamonganmegilan.png"),
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
                        controller: name,
                        decoration: InputDecoration(
                            labelText: "Nama",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: address,
                        decoration: InputDecoration(
                            labelText: "Alamat",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
                        obscureText: isShowPassword ? false : true,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye, color: (isShowPassword ? Colors.blue : Colors.black26),),
                              onPressed: () {
                                setState(() {
                                  isShowPassword = !isShowPassword;
                                });
                              },
                            ),
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: confirmPassword,
                        obscureText: isShowConfirmPassword ? false : true,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye, color: (isShowConfirmPassword ? Colors.blue : Colors.black26),),
                              onPressed: () {
                                setState(() {
                                  isShowConfirmPassword = !isShowConfirmPassword;
                                });
                              },
                            ),
                            labelText: "Konfirmasi Password",
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
                            "Sudah memiliki akun?",
                            style: TextStyle(fontSize: 15),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text("Login"))
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(child: Text("Registrasi")),
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
