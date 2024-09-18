import 'package:hive/hive.dart';
part 'hivemodel.g.dart';



@HiveType(typeId: 1)
class HiveModel extends HiveObject{

  @HiveField(0)
  int? id;

  @HiveField(1)
  String studentname;

  @HiveField(2)
  String studentage;

  @HiveField(3)
  String imagepath;

  

  HiveModel({ required this.studentname, required this.studentage,  required this.imagepath,this.id});

}