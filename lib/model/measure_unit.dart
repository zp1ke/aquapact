import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'symbol')
enum VolumeMeasureUnit {
  ml(factor: 1.0, symbol: 'ml', decimals: 0),
  l(factor: .001, symbol: 'l', decimals: 2);

  final double factor;
  final String symbol;
  final int decimals;

  const VolumeMeasureUnit({
    required this.factor,
    required this.symbol,
    required this.decimals,
  });

  String formatValue(double value, {bool withSymbol = true}) {
    final valueStr = (value * factor).toStringAsFixed(decimals);
    if (withSymbol) {
      return '$valueStr $symbol';
    }
    return valueStr;
  }
}
