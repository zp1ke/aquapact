import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../service/database.dart';
import 'objectbox.g.dart';

// https://docs.objectbox.io/getting-started#create-a-store
class ObjectBox implements DatabaseService {
  late final Store store;

  ObjectBox._create(this.store) {}

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "aqua_pact"));
    return ObjectBox._create(store);
  }
}
