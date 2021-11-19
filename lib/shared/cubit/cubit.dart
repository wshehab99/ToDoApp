import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../layout/screens/archived_tasks.dart';
import '../../layout/screens/done_tasks.dart';
import '../../layout/screens/new_tasks.dart';
import '../../shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());
  static AppCubit get(context) => BlocProvider.of(context);
  Database? dataBase;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  bool isBottomSheetShown = false;
  Icon fabIcon = Icon(Icons.edit);
  IconData? selectedIcon;
  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(ChangeNavgatationBarIndex());
  }

  void createDatabase() {
    openDatabase('toDo.db', version: 1, onCreate: (dataBase, version) async {
      print('database created');
      await dataBase.execute(
          'CREATE TABLE tasks ( id INTEGER PRIMARY KEY, title TEXT,date TEXT ,time TEXT, status TEXT, icon INTEGER)');
      print('table created');
    }, onOpen: (dataBase) {
      getDataFromDatabase(dataBase);
      print('database opened');
    }).then((value) {
      dataBase = value;
      emit(AppCreateDatabase());
    });
  }

  void insertToDatabast({
    @required String? title,
    @required String? time,
    @required String? date,
    required int icon,
  }) async {
    await dataBase!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status,icon) VALUES("$title","$date","$time","new","$icon")')
          .then((value) {
        print("inserted successfully$value");
        emit(AppInsertToDatabase());
        getDataFromDatabase(dataBase!);
      });
    });
  }

  void updateTaskStatus({required String? status, required int? id}) async {
    await dataBase!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ', [
      '$status',
      id,
    ]).then((value) {
      print(value);
      emit(AppChangeRowStatusState());
      getDataFromDatabase(dataBase!);
    });
  }

  void deleteTask({required String? id}) async {
    await dataBase!
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteTaskStatusState());
      getDataFromDatabase(dataBase!);
    });
  }

  void getDataFromDatabase(Database database) async {
    emit(AppLoadingtDatabase());
    newTasks = [];
    archivedTasks = [];
    doneTasks = [];
    emit(AppLoadingtDatabase());
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'archived')
          archivedTasks.add(element);
        else
          doneTasks.add(element);
      });
      emit(AppGetDatabase());
    });
  }

  void changeBottomSheetData({required Icon icon, required bool isShown}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

  void changeSelectedIcon({required IconData iconData}) {
    this.selectedIcon = iconData;
    emit(ChangeSelectedIcon());
  }
}
