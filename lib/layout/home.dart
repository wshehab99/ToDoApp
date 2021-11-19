import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../layout/screens/icon_screen.dart';
import '../../shared/constant.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeControler = TextEditingController();
  var dateControler = TextEditingController();

  Future<String> getName() async {
    return 'Ahmed Ali';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, AppStates state) {
          if (state is AppInsertToDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabast(
                        title: titleController.text,
                        time: timeControler.text,
                        date: dateControler.text,
                        icon: myIcon!.codePoint,
                      );
                      timeControler.clear();
                      titleController.clear();
                      dateControler.clear();
                      myIcon = null;
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                          (context) => Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Task Title',
                                      icon: Icon(Icons.title),
                                    ),
                                    controller: titleController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "title must not be empty";
                                      } else if (myIcon == null) {
                                        return 'icon must not be empety';
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: timeControler,
                                    decoration: InputDecoration(
                                      labelText: 'Task Time',
                                      icon: Icon(Icons.watch_later_outlined),
                                      //prefix:prefix,
                                    ),
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeControler.text =
                                            value!.format(context);
                                        print(value.format(context));
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: dateControler,
                                    decoration: InputDecoration(
                                      labelText: 'Task Date',
                                      icon: Icon(Icons.calendar_today),
                                      //prefix:prefix,
                                    ),
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now()
                                                  .add(Duration(days: 30)))
                                          .then((value) {
                                        dateControler.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  myIcon == null
                                      ? FlatButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    IconScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'add icon',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        )
                                      : Icon(myIcon),
                                ],
                              ),
                            ),
                          ),
                          elevation: 25,
                        )
                        .closed
                        .then((value) => {
                              cubit.changeBottomSheetData(
                                  icon: Icon(Icons.edit), isShown: false)
                            });
                    cubit.changeBottomSheetData(
                        icon: Icon(Icons.add), isShown: true);
                  }
                },
                child: cubit.fabIcon,
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeCurrentIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archived ')
                ],
              ),
              body: (!(state is AppLoadingtDatabase))
                  ? cubit.screens[cubit.currentIndex]
                  : Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
