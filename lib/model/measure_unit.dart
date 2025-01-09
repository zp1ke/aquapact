import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'symbol')
enum VolumeMeasureUnit {
  ml(factor: 0.001, symbol: 'ml'),
  l(factor: 1, symbol: 'l');

  final double factor;
  final String symbol;

  const VolumeMeasureUnit({
    required this.factor,
    required this.symbol,
  });
}
