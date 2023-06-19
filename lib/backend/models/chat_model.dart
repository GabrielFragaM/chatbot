
import 'package:chatbot/backend/models/random_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'date_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


enum TypeMessages {
  text
}

class ChatAppModel {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const openAIToken = 'XXXX';


  static Future<void> sendMessage({required List<Map<String, dynamic>> messages, required String message, required String chatId, required String userName, required String barberShopName, required TypeMessages type}) async {
    String messageId =  RandomServices.generateRandomId();

    Map<String, dynamic> currentUserMessageData = {
      'id': messageId,
      'order': (messages.length + 1).toString(),
      'senderId': userName,
      'username': userName,
      'assistantname': barberShopName,
      'userMessage': message,
      'assistantMessage': '',
      'type': type.name,
      'date': await DateServices.getCurrentUtcIso8601String(),
    };

    await _firestore.collection('chat').doc(chatId).collection('messages').doc(messageId).set(currentUserMessageData);

    String baseUrl = 'https://api.openai.com/v1/chat/completions';

    List<Map<String, String>> chatMessages = [
      {"role": "assistant", "content": 'Você é um assistente virtual de uma barbearia chamada $barberShopName. Por favor, responda de acordo com as seguintes diretrizes.'},
      {"role": "assistant", "content": 'Aqui está a lista das conversas anteriores: ${formatMessagesForChatGpt(messages)}. Sempre avalie a orderm das conversas e responda de acordo com o que já foi combinado ou conversado.'},
      {"role": "assistant", "content": 'No início de uma conversa (order "1"), cumprimente o usuário com "Bom dia", "Boa tarde" ou "Boa noite", dependendo do horário atual: ${currentUserMessageData['date']}. Use "Bom dia" das 6h às 12h, "Boa tarde" das 12h às 18h e "Boa noite" das 18h às 6h.'},
      {"role": "assistant", "content": 'A barbearia funciona das 8h às 19h. Não podemos agendar serviços fora deste horário.'},
      {"role": "assistant", "content": 'Esta é a conversa atual: $currentUserMessageData.'},
      {"role": "assistant", "content": 'Tente fornecer respostas que sejam concisas e diretas, de um jeito não formal algo com o sutaque do rio grande do sul.'},
      {"role": "assistant", "content": 'Nossos serviços são: Corte de cabelo por 30R\$ (duração de 1h), Barba por 15R\$ (duração de 30 minutos), e Sobrancelhas por 10R\$ (duração de 15 minutos).'},
      {"role": "assistant", "content": 'Antes de agendar um horário, pergunte ao usuário qual serviço ele gostaria de agendar.'},
      {"role": "assistant", "content": 'Quando fornecer opções de horários disponíveis, siga estas regras: 1. Não ofereça horários que estejam na lista de indisponíveis e verifique o dia atual desse agendamento caso usuário escolha "hoje" ou amanhã etc... 2. Os horários devem ser após a data e horário atual: ${currentUserMessageData['date']}. 3. O horário agendado deve se encaixar na disponibilidade da barbearia e na lista de horários indisponíveis. 4. Não mencione os horários indisponíveis para o usuário.'},
      {"role": "assistant", "content": 'Oferecemos café, jogos de sinuca e chopps aos clientes durante a espera.'},
      {"role": "assistant", "content": 'Cancelamentos são permitidos até 3 horas antes do horário agendado.'},
      {"role": "user", "content": message},
    ];

    String messagesJson = json.encode(chatMessages);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $openAIToken'
    };

    String body = '''
          {
            "messages": $messagesJson,
            "max_tokens": 4000,
            "model": "gpt-3.5-turbo"
          }
        ''';


    http.Response response = await http.post(Uri.parse(baseUrl), headers: headers, body: body);

    Map<String, dynamic> responseJson = json.decode(response.body);

    String messageChatResult = responseJson['choices'].last['message']['content'];


    Utf8Decoder decoder = const Utf8Decoder();

    String correctString = decoder.convert(latin1.encode(messageChatResult));

    String chatMessageId =  RandomServices.generateRandomId();

    await _firestore.collection('chat').doc(chatId).collection('messages').doc(chatMessageId).set({
      'id': chatMessageId,
      'order': (messages.length + 2).toString(),
      'senderId': barberShopName,
      'username': userName,
      'assistantname': barberShopName,
      'userMessage': message,
      'assistantMessage': correctString,
      'type': type.name,
      'date': await DateServices.getCurrentUtcIso8601String(),
    });

    await _firestore.collection('chat').doc(chatId).collection('messages').doc(messageId).update({
      'assistantMessage': correctString
    });
  }

  static List<Map<String, dynamic>> formatMessagesForChatGpt(List<Map<String, dynamic>> messages) {
    List<Map<String, dynamic>> formattedMessages = [];

    for (Map<String, dynamic> message in messages) {
      String role;
      String content;
      int order;

      if (message['senderId'] == message['username']) {
        role = 'user';
        content = message['userMessage'];
      } else if (message['senderId'] == message['assistantname']) {
        role = 'assistant';
        content = message['assistantMessage'];
      } else {
        throw Exception('Unknown senderId: ${message['senderId']}');
      }

      order = int.parse(message['order']);

      formattedMessages.add({'role': role, 'content': content, 'order': order, 'date': message['date']});
    }

    formattedMessages.sort((a, b) => a['order'].compareTo(b['order']));

    return formattedMessages;
  }



  factory ChatAppModel() => ChatAppModel._internal();
  ChatAppModel._internal();
}
