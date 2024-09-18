import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_bloc.dart';
import 'package:hive_bloc/src/presentation/cubit/bloc/hive_event.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_bloc/src/domain/models/hivemodel.dart';
import 'package:hive_bloc/src/presentation/homescreen/homepage.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(HiveModelAdapter().typeId)) {
    Hive.registerAdapter(HiveModelAdapter());
  }
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentBloc()..add(LoadStudentsEvent()), // Loading students on startup
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}
