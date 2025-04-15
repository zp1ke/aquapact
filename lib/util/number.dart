extension AppDouble on double {
  /// Rounds the current [double] value to the nearest hundred.
  double roundToNearestHundred() {
    return roundToNearest(100.0);
  }

  /// Rounds the current [double] value to the nearest multiple of [factor].
  double roundToNearest(double factor) {
    return (this / factor).ceil() * factor.toDouble();
  }
}

