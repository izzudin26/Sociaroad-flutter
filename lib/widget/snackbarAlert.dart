import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message){
  final snackBar = SnackBar(content: Text(message));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}