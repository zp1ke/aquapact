import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../service/database.dart';
import 'objectbox.g.dart';

// https://docs.objectbox.io/getting-started#create-a-store
class ObjectBox implements DatabaseService {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return createOn(docsDir);
  }

  static Future<ObjectBox> createOn(Directory directory) async {
    final storeDirectory = p.join(directory.path, 'aqua_pact');
    final store = await openStore(directory: storeDirectory);
    return ObjectBox._create(store);
  }
}
