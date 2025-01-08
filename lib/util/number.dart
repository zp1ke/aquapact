extension AppDouble on double {
  double roundToNearestHundred() {
    return roundToNearest(100.0);
  }

  double roundToNearest(double factor) {
    return (this / factor).ceil() * factor.toDouble();
  }
}
