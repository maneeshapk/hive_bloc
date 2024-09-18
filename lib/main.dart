import 'package:flutter/material.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';
import 'package:hive_bloc/src/presentation/homescreen/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main(List<String> args)  async{
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(HiveModelAdapter().typeId))
  {
    Hive.registerAdapter(HiveModelAdapter());
  }
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Homepage() ,
    );
  }
}