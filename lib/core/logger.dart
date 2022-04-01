import 'package:logger/logger.dart';

class Log {
  static d(dynamic msg) {
    Logger(printer: PrettyPrinter(printEmojis: false, printTime: false)).d(msg);
  }
  static i(dynamic msg) {
    Logger(printer: PrettyPrinter(printEmojis: false, printTime: false)).i(msg);
  }
}