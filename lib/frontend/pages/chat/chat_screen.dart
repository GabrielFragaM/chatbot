import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../backend/models/date_services.dart';
import 'widgets/input/input_widget.dart';
import 'widgets/messages/messages.dart';


class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> chatMapData;
  final String barberShopName;
  final String userName;

  const ChatScreen({super.key, required this.chatMapData, required this.barberShopName, required this.userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _controllerScrollChat = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  goToDownScrollChat() {
    try{
      setState(() {
        _controllerScrollChat.jumpTo(_controllerScrollChat.position.minScrollExtent);
      });
    }catch(e){}
  }


  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    if(keyboardIsOpen == true){
      goToDownScrollChat();
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF242525),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chat').doc(widget.chatMapData['id']).collection('messages').orderBy('date', descending: true).snapshots(),
              builder: (context, messagesQuery){
                if(!messagesQuery.hasData) {
                  return Container();
                } else {
                  return Stack(
                    children: <Widget>[
                      ListView.builder(
                        controller: _controllerScrollChat,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: messagesQuery.data!.docs.length,
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (context, index){
                          Map<String, dynamic> _currentMessage = messagesQuery.data!.docs[index].data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Container(
                              padding: const EdgeInsets.only(left: 13, right: 13, top: 10,),
                              child: Align(
                                  alignment: (_currentMessage['senderId'] != widget.userName ? Alignment.topLeft:Alignment.topRight),
                                  child: Column(
                                    crossAxisAlignment: _currentMessage['senderId'] != widget.userName ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                    children: [
                                      TypeText(currentMessage: _currentMessage, userId: widget.userName),
                                      const SizedBox(height: 5),
                                      Text(DateServices.formatChatStyleDate(context, _currentMessage['date']), style: const TextStyle(color: Colors.grey, fontSize: 13),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          );
                        },
                      ),
                      InputWidget(
                          chat: widget.chatMapData,
                          messages: convertFirestoreDataToList(messagesQuery.data!),
                          userName: widget.userName,
                          barberShopName: widget.barberShopName,
                          goToDownScrollChat: goToDownScrollChat
                      ),
                    ],
                  );
                }
              }
          )
      ),
    );
  }
}

List<Map<String, dynamic>> convertFirestoreDataToList(QuerySnapshot messagesQuery) {
  List<Map<String, dynamic>> messages = [];

  for (var document in messagesQuery.docs) {
    messages.add(document.data() as Map<String, dynamic>);
  }

  print(messages);

  return messages;
}