import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'url.dart';

class AuthService {
  static Future<void> registration(
      {required String name,
      required String email,
      required String address,
      required String password}) async {
    Uri url = Uri.parse("$serverUrl/user");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'address': address
      };
      final res = await http.post(url, body: body, headers: {
        'authorization': userCredential.user!.uid,
      });
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'];
      }
    } on FirebaseAuthException catch (ef) {
      if (ef.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (ef.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<void> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential.user);
    } on FirebaseAuthException catch (ef) {
      if (ef.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (ef.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      throw e;
    }
  }
}
