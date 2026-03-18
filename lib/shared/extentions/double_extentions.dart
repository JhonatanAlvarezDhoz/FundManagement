import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  String toCurrency({
    String locale = 'es_CO',
    String symbol = 'COP ',
    int decimals = 0,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimals,
    );

    return formatter.format(this);
  }
}

extension PercentageFormatter on double {
  String toPercentage() {
    return '${(this * 100).toStringAsFixed(0)}%';
  }
}
