import 'package:logger/logger.dart';

class Log {
  static d(dynamic msg) {
    Logger(printer: PrettyPrinter(printEmojis: true, colors: true, printTime: false)).d(msg);
  }
  static i(dynamic msg) {
    Logger(printer: PrettyPrinter(printEmojis: true, colors: true, printTime: false)).i(msg);
  }
}