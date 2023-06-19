import 'package:chatbot/backend/models/date_services.dart';
import 'package:chatbot/backend/models/random_services.dart';
import 'package:chatbot/frontend/pages/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController barberShopNameController = TextEditingController();

  Future<void> navigateToNextScreen(BuildContext context) async {
    String userName = userNameController.text;
    String barberShopName = barberShopNameController.text;

    Map<String, dynamic> chatMapData = {
      'id': RandomServices.generateRandomId(),
      'userName': userName,
      'barberShopName': barberShopName,
      'date': await DateServices.getCurrentUtcIso8601String()
    };

    await FirebaseFirestore.instance.collection('chat').doc(chatMapData['id']).set(chatMapData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatMapData: chatMapData, userName: userName, barberShopName: barberShopName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Teste fechado para projeto barbearia de conversa automática 1.0v'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: 'Digite seu nome',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: barberShopNameController,
                  decoration: InputDecoration(
                    hintText: 'Digite o nome da barbearia',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => navigateToNextScreen(context),
                  child: Text('Iniciar Conversa'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}