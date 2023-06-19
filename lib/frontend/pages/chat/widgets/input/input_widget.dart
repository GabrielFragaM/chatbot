import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../../../../backend/models/chat_model.dart';

class InputWidget extends StatefulWidget {
  final Map<String, dynamic> chat;
  final List<Map<String, dynamic>> messages;
  final String userName;
  final String barberShopName;
  final Function goToDownScrollChat;


  const InputWidget({
    super.key, required this.chat, required this.messages, required this.userName, required this.barberShopName, required this.goToDownScrollChat
  });

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {

  final TextEditingController _messageText = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 5),
            child: SizedBox(
              height: 65,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151517),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _messageText,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                                hintText: FlutterI18n.translate(context, 'digite sua mensagem...'),
                                hintStyle: const TextStyle(color: Color(0xFFB9B9B9), fontSize: 15),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        GestureDetector(
                          onTap: () async {
                            if(_messageText.text.isEmpty) {
                              return;
                            }

                            ChatAppModel.sendMessage(
                              messages: widget.messages,
                              chatId: widget.chat['id'],
                              userName: widget.userName,
                              barberShopName: widget.barberShopName,
                              message: _messageText.text, type: TypeMessages.text,
                            ).then((value) => widget.goToDownScrollChat());

                            setState(() {
                              _messageText.text = '';
                            });
                          },
                          child: const Icon(Icons.send_outlined, color: Colors.white),
                        ),
                        const SizedBox(width: 15,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            )
        )
    );
  }
}