import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser!;
    setState(() {
      email.text = user.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/account.json'),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                readOnly: true,
                controller: email,
                decoration: InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.email)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text("Logout Account")),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
