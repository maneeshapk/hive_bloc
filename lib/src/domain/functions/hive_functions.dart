import 'package:hive/hive.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';



// add function
Future<void> addstudentinfo(HiveModel data) async {
  var userDB = await Hive.openBox<HiveModel>("studentBox");
  final _id = await userDB.add(data);
  data.id = _id;
  await data.save(); 
}


// Get function
Future<Iterable<HiveModel>> getstudentinfo() async {
  var userDB = await Hive.openBox<HiveModel>("studentBox");
  return userDB.values;
}

// Delete function
Future<void> deletestudentinfo(int id) async {
  var userDB = await Hive.openBox<HiveModel>("studentBox");
  await userDB.delete(id);
}

// update function

Future<void> updatestudentinfo(HiveModel updatedEvent) async {
  var userDB = await Hive.openBox<HiveModel>("studentBox");
  final id = updatedEvent.id;
  if (id != null) {
    await userDB.put(id, updatedEvent);
  }
}


// crud operations done
