import 'package:flutter/material.dart';

class DialogServices {

  static showErrorDialog({required BuildContext context, required String title, required String desc, String? btnOkText}){

  }

  static showWarningDialog({required BuildContext context, required String title, required String desc, String? btnOkText, void Function()? btnOkOnPress, void Function()? btnCancelOnPress, String? btnCancelText}){

  }

  factory DialogServices() => DialogServices._internal();
  DialogServices._internal();
}
