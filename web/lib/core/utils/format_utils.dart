import 'package:intl/intl.dart';

class FormatUtils {
  static String formatNumber(num value) {
    return NumberFormat('#,###').format(value);
  }

  static String formatCurrency(num value) {
    return NumberFormat('#,###').format(value);
  }
}
