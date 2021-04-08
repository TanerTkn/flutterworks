import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todolist/home.dart';

main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      home: Home(),
    );
  }
}
