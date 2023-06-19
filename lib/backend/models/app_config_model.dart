import 'package:flutter/material.dart';


class AppConfigModel {
  static String title = 'Teste Fechado Barbearias';

  static initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  factory AppConfigModel() => AppConfigModel._internal();
  AppConfigModel._internal();
}