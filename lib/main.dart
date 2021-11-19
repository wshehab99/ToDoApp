import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'layout/home.dart';
import 'shared/bloc_observer.dart';

void main(List<String> args) {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
