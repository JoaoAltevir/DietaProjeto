import 'dart:io';

import 'package:mydiet/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxDatabase {
  /// The Store of this app.
  late final Store store;
  ObjectBoxDatabase._create(this.store);

  static Future<ObjectBoxDatabase> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbDir = Directory( p.join(docsDir.path, "obx-example"));
    if(!dbDir.existsSync()){
      await dbDir.create(recursive: true);
    }
    final store = await openStore(directory:dbDir.path);
    return ObjectBoxDatabase._create(store);
  }
}

ObjectBoxDatabase? objectBox;
Future<ObjectBoxDatabase> startObjectBox() async {
  return objectBox ??= await ObjectBoxDatabase.create();
}
