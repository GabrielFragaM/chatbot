import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

import 'app_theme_model.dart';


class DateServices {
  static Future<DateTime> getCurrentTime() async {
    DateTime currentTime = DateTime.now();
    return currentTime;
  }

  static Future<String> getCurrentUtcIso8601String() async {
    DateTime utcTimestamp = (await getCurrentTime()).toUtc();
    return utcTimestamp.toIso8601String();
  }

  static DateTime iso8601StringToLocalDateTime(String iso8601String) {
    DateTime utcTimestamp = DateTime.parse(iso8601String);
    return utcTimestamp.toLocal();
  }

  static String fixDeadlineDateIso8601Bids(String date) {
    DateTime inputDate = DateTime.parse(date);
    DateTime deadlineDate = DateTime(inputDate.year, inputDate.month, inputDate.day, 23, 59);
    return deadlineDate.toIso8601String();
  }

  static String formatChatStyleDate(BuildContext context, String iso8601String) {
    DateTime dateTime = DateTime.parse(iso8601String);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    String getTranslateMessage(String message){
      return FlutterI18n.translate(context, message);
    }

    if (difference.inMinutes < 1) {
      return getTranslateMessage('agora');
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} ${getTranslateMessage('min')}';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ${getTranslateMessage('h')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays > 1 ? getTranslateMessage('dias') : getTranslateMessage('dia')}';
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks ${getTranslateMessage('semana')}';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months ${getTranslateMessage('mês')}';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years ${getTranslateMessage('ano')}';
    }
  }

  static Future<String> getFormatLocalDateTime(BuildContext context, DateTime localDateTime) async {
    await initializeDateFormatting();
    String formattedDate = DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(localDateTime);
    return formattedDate;
  }

  static bool isIso8601String(String value) {
    try {
      DateTime.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  static int daysBetween(DateTime date1, DateTime date2) {
    return (date1.difference(date2).inHours / 24).round();
  }

  static Future<String?> getDateFromDatePicker(context, {int? firstDateYear, int? lastDateYear, bool disablePastDate = false}) async {
    DateTime now = await getCurrentTime();

    DateTime? date = await showDatePicker(
        context: context,
        locale: Locale(FlutterI18n.currentLocale(context)!.languageCode),
        initialDate: now,
        firstDate: disablePastDate ? DateTime(now.year, now.month, now.day) : DateTime(firstDateYear ?? 1900),
        lastDate: DateTime(lastDateYear ?? 2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppThemeModel.themeColorPrimary,
                onPrimary: AppThemeModel.themeColorSecondary,
                onSurface: AppThemeModel.themeColorPrimary,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppThemeModel.themeColorPrimary,
                ),
              ),
            ),
            child: child ?? Container(),
          );
        });

    if (date != null) {
      return date.toUtc().toIso8601String();
    } else {
      return null;
    }
  }

  factory DateServices() => DateServices._internal();
  DateServices._internal();
}
