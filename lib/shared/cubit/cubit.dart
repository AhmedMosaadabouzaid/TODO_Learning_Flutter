import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/archived_tasks/archived_tasks.dart';
import 'package:todo/models/done_tasks/done_tasks.dart';
import 'package:todo/models/new_tasks/new_tasks.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<String> pageNames = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> pages = [NewTasks(), DoneTasks(), ArchivedTasks()];
  int pageIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database appDB;

  changePageIndex(int index) {
    pageIndex = index;
    emit(AppChangeIndex());
  }

  bool isBottomSheetOpen = false;
  IconData fabIcon = Icons.add;

  changeBottomSheet(bool isOpen, IconData iconData) {
    isBottomSheetOpen = isOpen;
    fabIcon = iconData;
    emit(AppChangeBottomSheetState());
  }

  createDB() {
    openDatabase('appDB.db', version: 1, onCreate: (db, version) {
      db
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then(
            (value) => print("table created"),
          )
          .catchError(onError);
    }, onOpen: (db) {
      getDataFromDatabase(db);
      print("DataBase Opened");
    }).then((value) {
      appDB = value;
      emit(AppCreateDBState());
    });
  }

  getDataFromDatabase(Database db) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoadingCircleState());

    db.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetFromDBState());
    });
  }

  insertIntoDB(
    String task,
    String date,
    String time,
  ) {
    appDB.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time , status) VALUES ("$task","$date","$time","new")')
          .then((value) {
        print('raw inserted succefully : $value');
        emit(AppInsertIntoDBState());
        getDataFromDatabase(appDB);
      }).catchError(onError);

      // return null;
    });
  }

  updateDb(String status, int id) {
    appDB.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', '$id'],
    ).then((value) {
      getDataFromDatabase(appDB);
      emit(AppUpdateDBState());
    });
  }

  deleteFromDB(int id) {
    appDB.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(appDB);
      emit(AppDeleteFromDBState());
    });
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
