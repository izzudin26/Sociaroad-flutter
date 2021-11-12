import 'dart:async';

import 'package:flutter/material.dart';
import 'package:society_road/registration.dart';

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
    // TODO: implement initState
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        isShowForm = true;
      });
    });
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
                          obscureText: !isShowPassword ? true :  false,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: (){
                              setState(() {
                                isShowPassword = !isShowPassword;
                              });
                            }, icon: Icon(Icons.remove_red_eye, color: isShowPassword ? Colors.blue : Colors.black26,)),
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
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Registration()));
                                },
                                child: Text("Daftar"))
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {},
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
