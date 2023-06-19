import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ValidatorService {

  String? validateText(BuildContext context, text){
    if(text.isEmpty) return FlutterI18n.translate(context, 'obrigatório');
    return null;
  }


}