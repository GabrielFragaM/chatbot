import 'dart:math';

class RandomServices {
  static const String _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  static String generateSecurityCode() {
    int min = 100000;
    int max = 999999;
    Random random = Random();
    int randomCode = min + random.nextInt(max - min);
    return randomCode.toString();
  }

  static String generateRandomId([int length = 20]) {
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));
  }

  static int generateNotificationId() {
    final random = Random();
    int id = random.nextInt(1 << 31);

    return id;
  }

  factory RandomServices() => RandomServices._internal();
  RandomServices._internal();
}