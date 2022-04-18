import 'package:logger/logger.dart';

class Log {
  static d(dynamic msg) {
    Logger(printer: PrettyPrinter(printEmojis: true, colors: false, printTime: true, methodCount: 0)).d(msg);
  }
  static i(dynamic msg) {
    Logger(printer: PrettyPrinter(printEmojis: true, colors: false, printTime: true, methodCount: 0)).i(msg);
  }
  static e(dynamic msg) {
    Logger(printer: PrettyPrinter(printEmojis: true, colors: false, printTime: true, methodCount: 0)).e(msg);
  }
}