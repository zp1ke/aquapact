import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    excludePaths: [
      'package:learner/utils/logger.dart',
    ],
  ),
);

extension AppLogger on String {
  void log() {
    logger.i(this);
  }

  void logError({
    Object? error,
    StackTrace? stackTrace,
  }) {
    logger.e(this, error: error, stackTrace: stackTrace);
  }
}
