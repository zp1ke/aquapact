enum VolumeMeasureUnit {
  ml(factor: 0.001, symbol: 'ml');

  final double factor;
  final String symbol;

  const VolumeMeasureUnit({
    required this.factor,
    required this.symbol,
  });
}
