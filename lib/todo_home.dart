import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class TODOHome extends StatelessWidget {
  const TODOHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();
    var noteTextController = TextEditingController();
    var timeTextController = TextEditingController();
    var dateTextController = TextEditingController();
    return BlocProvider(
      create: (context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AppInsertIntoDBState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.pageNames[cubit.pageIndex]),
            ),
            body: state is! AppLoadingCircleState
                ? cubit.pages[cubit.pageIndex]
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                cubit.changePageIndex(value);
              },
              currentIndex: cubit.pageIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: "New Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_box,
                    ),
                    label: "Done Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive,
                    ),
                    label: "Archived Tasks"),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetOpen) {
                  if (formKey.currentState!.validate()) {
                    //  cubit.isBottomSheetOpen=false;
                    //  cubit.fabIcon=Icons.edit;
                    //  Navigator.pop(context);
                    cubit.insertIntoDB(noteTextController.text,
                        dateTextController.text, timeTextController.text);
                    noteTextController.text = '';
                    dateTextController.text = '';
                    timeTextController.text = '';
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        return Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defulatTextFormField(
                                    onTapFunction: () {},
                                    textEditingController: noteTextController,
                                    labelText: "Enter Note",
                                    prefixIcon: (Icons.note_add),
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "Note can not be empty";
                                      }
                                    },
                                    onChange: () {},
                                    onSubmit: () {},
                                    inputType: TextInputType.text,
                                    isObsecure: false),
                                SizedBox(height: 10.0),
                                defulatTextFormField(
                                    onTapFunction: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse("2050-12-30"))
                                          .then((value) {
                                        dateTextController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    textEditingController: dateTextController,
                                    labelText: "Enter Date",
                                    prefixIcon: (Icons.calendar_today),
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "Date can not be empty";
                                      }
                                    },
                                    onChange: () {},
                                    onSubmit: () {},
                                    inputType: TextInputType.text,
                                    isObsecure: false),
                                SizedBox(height: 10.0),
                                defulatTextFormField(
                                    onTapFunction: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeTextController.text =
                                            value!.format(context);
                                      });
                                    },
                                    textEditingController: timeTextController,
                                    labelText: "Enter Time",
                                    prefixIcon: (Icons.schedule),
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "Time can not be empty";
                                      }
                                    },
                                    onChange: () {},
                                    onSubmit: () {},
                                    inputType: TextInputType.text,
                                    isObsecure: false),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cubit.changeBottomSheet(false, Icons.add);
                      });
                  cubit.changeBottomSheet(true, Icons.edit);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
