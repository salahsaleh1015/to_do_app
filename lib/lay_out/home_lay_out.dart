import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/module/archived/archived_tasks_screen.dart';
import 'package:to_do_app/module/done_task/done_task.dart';
import 'package:to_do_app/module/new_task/new_tasks_screen.dart';
import 'package:to_do_app/shared/component/constants.dart';
import 'package:to_do_app/shared/component/reusable.dart';

class HomeLayOut extends StatefulWidget {
  const HomeLayOut({Key? key}) : super(key: key);

  @override
  _HomeLayOutState createState() => _HomeLayOutState();
}

class _HomeLayOutState extends State<HomeLayOut> {
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = ["new tasks", "done tasks ", " archived tasks"];
  late Database database;
  int currentIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.add;
  var textController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    createDatabase();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertIntoDatabase(
                name: textController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                getDataFromDatabase(database).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    isBottomSheetShown = false;
                    fabIcon = Icons.edit;
                    tasks = value;
                    print(tasks);
                  });
                });



              });
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet((context) =>
                Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.grey[100],
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultFormField(
                            textController: textController,
                            type: TextInputType.text,
                            validate: (String? val) {
                              if (val!.isEmpty) {
                                return "you must type something";
                              }
                            },
                            prefix: Icons.title,
                            label: "enter your title"),
                        SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                            onTap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                              });
                            },
                            textController: timeController,
                            type: TextInputType.text,
                            validate: (String? val) {
                              if (val!.isEmpty) {
                                return "you must pick time";
                              }
                            },
                            prefix: Icons.watch_later_outlined,
                            label: "enter your time"),
                        SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-05-05'))
                                  .then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            },
                            textController: dateController,
                            type: TextInputType.text,
                            validate: (String? val) {
                              if (val!.isEmpty) {
                                return "you must pick date";
                              }
                            },
                            prefix: Icons.calendar_today,
                            label: "enter your date")
                      ],
                    ),
                  ),
                ));
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.list
              ),
              label: "new Tasks"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle,
              ),
              label: "done Tasks"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive_outlined,
              ),
              label: "archived Tasks"),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: ConditionalBuilder(
          builder: (context)=>screens[currentIndex],
        condition:tasks.length>0,
          fallback: (context)=>CircularProgressIndicator(),
          ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'salah.db',
      version: 1,
      onCreate: (database, version) {
        print('db created');
        database
            .execute(
            'CREATE TABLE todo (id INTEGER PRIMARY KEY , name TEXT, time TEXT , date TEXT , status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print(' error is ${error.toString()}');
        });
      },
     onOpen: (database){
        print("database opened");
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(tasks);
        });

     }
    );
  }

  Future insertIntoDatabase(
      {@required name, @required time, @required date }) async {
    return await database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO todo (name , time , date , status) VALUES ("$name","$time","$date","new") ')
          .then((value) => print("$value "))
          .catchError((error) {
        print("${error.toString()}");
      });
    });
  }
  Future<List<Map>> getDataFromDatabase(database)async{
    return await database.rawQuery('SELECT * FROM todo');
  }
  

}
