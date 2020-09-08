import 'package:flutter/material.dart';
import 'package:todotrack/models/models.dart';
import 'package:todotrack/screens/homescreen.dart';
import 'package:todotrack/utils/database.dart';
import 'package:todotrack/values/contants.dart';
import 'package:todotrack/widgets/widgets.dart';

class TaskScreen extends StatefulWidget {
  final Task task;

  TaskScreen({@required this.task});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController titleController, descController;
  DatabaseManager databaseManager;
  bool _hasTask;
  String taskTitle, taskDescription;

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController();
    descController = TextEditingController();
    databaseManager = DatabaseManager();
    if (widget.task == null) {
      _hasTask = false;
    } else {
      _hasTask = true;
      taskTitle = widget.task.taskTitle;
      taskDescription = widget.task.taskDescription;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLiteColor,
      appBar: AppBar(
        title: Text("Create a new Task.."),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
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
                              style: TextStyle(color: kPrimaryColor),
                            )
                          : TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: "Enter Task Title ",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w900),
                            ),
                    ),
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
                              style: TextStyle(color: kPrimaryColor),
                            )
                          : TextField(
                              controller: descController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
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
                              onPressed: () async {
                                String title =
                                    titleController.value.text.toString();
                                String desc =
                                    descController.value.text.toString();
                                Task task = Task(
                                  taskTitle: title,
                                  taskDescription: desc,
                                );

                                if (title != "" && desc != "" && title != null && desc != null) {
                                  await databaseManager.insertTask(task);
                                  Navigator.pop(context);
                                } else {
                                  print("Fill both the fields");
                                }
                              },
                              child: Text(
                                "save",
                                style: TextStyle(color: kLiteColor),
                              ),
                              color: kPrimaryColor,
                            ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _hasTask,
                child: Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async {
                      await databaseManager
                          .deleteTask(widget.task.taskId)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: kDarkColor,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: kLiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
