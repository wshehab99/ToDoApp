import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewTasksState();
  }
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return ListView.separated(
            itemBuilder: ((context, index) {
              return Slidable(
                startActionPane: ActionPane(
                  extentRatio: 0.19,
                  motion: DrawerMotion(),
                  children: <Widget>[
                    SlidableAction(
                      onPressed: (context) {
                        AppCubit.get(context)
                            .deleteTask(id: tasks[index]['id'].toString());
                        Fluttertoast.showToast(
                          msg: 'Task deleted',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                        );
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  extentRatio: 0.408,
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (context) {
                        AppCubit.get(context).updateTaskStatus(
                            status: 'archived', id: tasks[index]['id']);
                        Fluttertoast.showToast(
                          msg: 'Task archived',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                        );
                      },
                      backgroundColor: Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.archive,
                      label: 'Archive',
                    ),
                    SlidableAction(
                      flex: 1,
                      onPressed: (context) {
                        AppCubit.get(context).updateTaskStatus(
                            status: 'done', id: tasks[index]['id']);
                        Fluttertoast.showToast(
                          msg: 'Task marcked as done',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                        );
                      },
                      backgroundColor: Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.check,
                      label: 'Done',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    IconData(
                      tasks[index]['icon'],
                      fontFamily: 'MaterialIcons',
                      matchTextDirection: true,
                    ),
                    size: 45,
                  ),
                  title: Text(
                    tasks[index]['title'].toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(tasks[index]['date'].toString()),
                  dense: false,
                  trailing: Text(
                    tasks[index]['time'],
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              );
            }),
            separatorBuilder: ((context, index) {
              return Divider();
            }),
            itemCount: tasks.length);
      },
    );
  }
}
