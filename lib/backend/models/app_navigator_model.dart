import 'package:chatbot/frontend/pages/home/home_page.dart';
import 'package:flutter/material.dart';

enum AppPages {
  pop, home,
}

class AppNavigatorModel {

  static AppPages currentPage = AppPages.home;

  static navigateToPage(
      {required BuildContext context,
        required AppPages page,
        Map<String, dynamic>? args,
      }) async {

    switch (page){
      case AppPages.pop:
        Navigator.pop(context);
        return;
      case AppPages.home:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
    }
  }

  factory AppNavigatorModel() => AppNavigatorModel._internal();
  AppNavigatorModel._internal();
}