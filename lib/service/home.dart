import '../app/di.dart';

abstract class HomeService {
  static HomeService get() => service<HomeService>();

  Future<void> updateData();
}
