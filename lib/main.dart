import 'package:chatbot/frontend/pages/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend/models/app_config_model.dart';
import 'backend/models/app_language_model.dart';
import 'backend/models/app_theme_model.dart';

void main() async {
  await AppConfigModel.initializeApp();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAGGADu7lhB3z1DRcjjTbrhpI0j5Jhnb9Q",
        authDomain: "chatbot-b1cff.firebaseapp.com",
        projectId: "chatbot-b1cff",
        storageBucket: "chatbot-b1cff.appspot.com",
        messagingSenderId: "999990513395",
        appId: "1:999990513395:web:c62eedb3ebed18419c3186"
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: AppConfigModel.title,
      debugShowCheckedModeBanner: false,
      theme: AppThemeModel.themeApp,
      locale: languageProvider.locale,
      color: Colors.red,
      supportedLocales: languageProvider.supportedLocales,
      localizationsDelegates: languageProvider.localizationsDelegates(fallbackFile: languageProvider.fallbackFile, locale: languageProvider.locale),
      home: const HomePage(),
    );
  }
}