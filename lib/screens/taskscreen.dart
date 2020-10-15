import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:todotrack/models/models.dart';
import 'package:todotrack/screens/homescreen.dart';
import 'package:todotrack/utils/alertdialogs.dart';
import 'package:todotrack/utils/database.dart';
import 'package:todotrack/values/contants.dart';
import 'package:todotrack/widgets/widgets.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class TaskScreen extends StatefulWidget {
  final Task task;

  TaskScreen({@required this.task});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

//Future<void> _configureLocalTimeZone() async {
//  tz.initializeTimeZones();
//  final String timeZoneName = await platform.invokeMethod("getTimeZoneName");
//  tz.setLocalLocation(tz.getLocation(timeZoneName));
//}
//
//const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController titleController, descController, todoController;
  DatabaseManager databaseManager;
  bool _hasTask;
  String taskTitle, taskDescription;
  int _isDone = 0;
  bool _titleValidate = false, _descValidate = false, _todoValidate = false;
  DateTime deadlineDateTime;

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController();
    descController = TextEditingController();
    todoController = TextEditingController();
    databaseManager = DatabaseManager();
    if (widget.task == null) {
      _hasTask = false;
    } else {
      _hasTask = true;
      taskTitle = widget.task.taskTitle;
      taskDescription = widget.task.taskDescription;
    }
//    configurationTime();
    super.initState();
  }
//
//  void configurationTime() async{
//    await _configureLocalTimeZone();
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    todoController.dispose();
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void saveDataToDatabase() async {
    String title = titleController.value.text.toString();
    String desc = descController.value.text.toString();
    Task task = Task(
      taskTitle: title,
      taskDescription: desc,
    );
    if (title != "" && desc != "" && title != null && desc != null) {
//    if (title != ""&& title != null) {
      await databaseManager.insertTask(task);
      Navigator.pop(context);
    } else {
      print("Fill both the fields");
      setState(() {
        titleController.text.isEmpty
            ? _titleValidate = true
            : _titleValidate = false;
        descController.text.isEmpty
            ? _descValidate = true
            : _descValidate = false;
      });
    }
  }

  void saveTodoToDatabase() async {
    String todoTitle = todoController.value.text.toString();
    if (todoTitle != "" && todoTitle != null) {
      String dateTimeToString;
      if (deadlineDateTime == null) {
        dateTimeToString = null;
      } else {
        dateTimeToString = deadlineDateTime.toIso8601String();

        var ans = await databaseManager.getLastId();
        int maxTodoID;
        if (ans[0]["max(todoId)"] == null){
          maxTodoID = 1;
        }else{
          maxTodoID = ans[0]["max(todoId)"] + 1;
        }
        var notificationId = int.parse(widget.task.taskId.toString() + maxTodoID.toString());
        print(notificationId);
        scheduleAlarm(deadlineDateTime, todoTitle, notificationId, taskTitle);
        deadlineDateTime = null;
      }
      Todo todo = Todo(
          todoTitle: todoTitle,
          todoIsDone: 0,
          taskId: widget.task.taskId,
          deadlineDateTime: dateTimeToString);
      await databaseManager.insertTodo(todo);
      todoController.clear();
      print("todo added to the task " + widget.task.taskId.toString());
      setState(() {
        _todoValidate = false;
      });
    } else {
      setState(() {
        todoController.text.isEmpty
            ? _todoValidate = true
            : _todoValidate = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLiteColor,
      appBar: AppBar(
        title: Text(
          _hasTask ? widget.task.taskTitle : "Create a new Task..",
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              AlertDialogs alert = AlertDialogs();
              await alert.showDialogForTotalTaskDelete(
                  context, widget.task.taskId);
            },
            child: Visibility(
              visible: _hasTask,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.delete),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),

                    //add task title
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: _hasTask
                          ? Text(
                              taskTitle,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: "Enter Task Title ",
                                errorText: _titleValidate
                                    ? "Title can't be empty"
                                    : null,
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),

                    //add task desc
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: _hasTask
                          ? Text(
                              taskDescription,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : TextField(
                              controller: descController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorText: _descValidate
                                    ? "Description can't be empty"
                                    : null,
                                hintText:
                                    "Enter the description of your task...",
                                hintStyle: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              maxLines: 5,
                              style: TextStyle(
                                  fontSize: 12.0, color: kPrimaryColor),
                            ),
                    ),

                    //save button and button action
                    Container(
                      margin: EdgeInsets.only(left: 20.0),
                      child: _hasTask
                          ? SizedBox(
                              width: 10.0,
                            )
                          : RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: 60.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                saveDataToDatabase();
                              },
                              child: Text(
                                "save",
                                style: TextStyle(color: kLiteColor),
                              ),
                              color: kPrimaryColor,
                            ),
                    ),

                    // toodo list here
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      child: _hasTask
                          ? FutureBuilder(
                              future: databaseManager
                                  .getAllTodos(widget.task.taskId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Todo> todoList = snapshot.data;
                                  return Container(
                                      child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: todoList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 10.0),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 0.0),
                                        decoration: BoxDecoration(
                                          color: kWhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                child: TodoWidget(
                                                  isDone: todoList[index]
                                                              .todoIsDone ==
                                                          0
                                                      ? false
                                                      : true,
                                                  title:
                                                      todoList[index].todoTitle,
                                                  dateTime: todoList[index]
                                                      .deadlineDateTime,
                                                ),
                                                onTap: () async {
                                                  int isdone = todoList[index].todoIsDone == 0 ? 1: 0 ;
                                                  await databaseManager
                                                      .updateTodoDone(
                                                          todoList[index]
                                                              .todoId,
                                                          isdone);
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Icon(
                                                Icons.delete,
                                                color: kPrimaryColor,
                                              ),
                                              onTap: () async {
                                                int todoId = todoList[index].todoId;
                                                await databaseManager
                                                    .deleteTodo(todoId);
                                                cancelAlarm(widget.task.taskId, todoId);
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ));
                                } else if (snapshot.hasError) {
                                  return Container(
                                    child: Text(snapshot.error),
                                  );
                                } else {
                                  return Container(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )
                          : SizedBox(),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),

                    //add a toodo widget here
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      color: kLiteColor,
                      child: !_hasTask
                          ? SizedBox(
                              width: 10.0,
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kWhiteColor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: todoController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          style: TextStyle(
                                            color: _isDone == 1
                                                ? kPrimaryColor
                                                : kDarkColor.withOpacity(0.6),
                                          ),
                                          decoration: InputDecoration(
                                              hintText: "Add a todo..",
                                              hintMaxLines: 2,
                                              errorText: _todoValidate
                                                  ? "Type an activity here"
                                                  : null,
                                              border: InputBorder.none),
                                        ),
                                        deadlineDateTime == null
                                            ? SizedBox()
                                            : Text(
                                                deadlineDateTime
                                                    .toIso8601String(),
                                                style: TextStyle(
                                                    color: kDarkColor
                                                        .withOpacity(0.6),
                                                    fontSize: 8.0),
                                              )
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      deadlineDateTime =
                                          await DatePicker.showDateTimePicker(
                                              context);
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      margin: EdgeInsets.only(right: 5.0),
                                      decoration: BoxDecoration(
                                          color: kDarkColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Center(
                                        child: Icon(
                                          Icons.timer,
                                          color: kLiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      saveTodoToDatabase();
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                          color: kDarkColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Center(
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: kLiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void scheduleAlarm(DateTime scheduledNotificationDateTime, String title, int notificationId, String taskTitle) async {
  final Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;
  vibrationPattern[3] = 5000;
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'todologo',
    sound: RawResourceAndroidNotificationSound('tone_notification'),
    largeIcon: DrawableResourceAndroidBitmap('todologo'),
    vibrationPattern: vibrationPattern
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'tone_notification.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  //  var dateTime = tz.TZDateTime.from(scheduledNotificationDateTime, tz.local).add(Duration(hours: 6));
  //  await flutterLocalNotificationsPlugin.zonedSchedule(0, title, "it's time to complete it.",
  //      dateTime, platformChannelSpecifics,
  //      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true);
  //  print("done at : ");
  //  print(dateTime);
  await flutterLocalNotificationsPlugin.schedule(
      notificationId,
      taskTitle,
      title,
      scheduledNotificationDateTime,
      platformChannelSpecifics);


}
void cancelAlarm(int taskId, int todoID) async {
  var notificationId = int.parse(taskId.toString() + todoID.toString());
  print(notificationId);
  await flutterLocalNotificationsPlugin.cancel(notificationId);
}
