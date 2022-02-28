import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/lay_out/home_lay_out.dart';
import 'package:to_do_app/module/counter/counter_screen.dart';
import 'package:to_do_app/shared/style/bloc_observer.dart';

void main() {


  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayOut(),
    );
  }
}
