import 'package:flutter/material.dart';
import 'package:todotrack/models/models.dart';
import 'package:todotrack/screens/homescreen.dart';
import 'package:todotrack/utils/alertdialogs.dart';
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
  TextEditingController titleController, descController, todoController;
  DatabaseManager databaseManager;
  bool _hasTask;
  String taskTitle, taskDescription;
  int _isDone = 0;
  bool _titleValidate = false, _descValidate = false, _todoValidate = false;

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
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    todoController.dispose();
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void saveDataToDatabase() async {
    String title =
    titleController.value.text.toString();
    String desc =
    descController.value.text.toString();
    Task task = Task(
      taskTitle: title,
      taskDescription: desc,
    );

    if (title != "" &&
        desc != "" &&
        title != null &&
        desc != null) {
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
    String todoTitle =
    todoController.value.text.toString();
    if (todoTitle != "" &&
        todoTitle != null) {
      Todo todo = Todo(
          todoTitle: todoTitle,
          todoIsDone: 0,
          taskId: widget.task.taskId);
      await databaseManager.insertTodo(todo);
      todoController.clear();
      print("todo added to the task " +
          widget.task.taskId.toString());
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
                padding: const EdgeInsets.only(right : 16.0),
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
                            style: TextStyle(color: kPrimaryColor),
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
                              style: TextStyle(color: kPrimaryColor),
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
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                child: TodoWidget(
                                                  isDone: todoList[index].todoIsDone == 0 ? false : true,
                                                  title:
                                                      todoList[index].todoTitle,
                                                ),
                                                onTap: () async {
                                                  int isdone = todoList[index].todoIsDone == 0 ? 1 : 0;
                                                  await databaseManager.updateTodoDone(todoList[index].todoId, isdone);
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              child: Icon(
                                                Icons.delete,
                                                color: kDarkColor
                                                    .withOpacity(0.80),
                                              ),
                                              onTap: () async {
                                                await databaseManager
                                                    .deleteTodo(
                                                        todoList[index].todoId);
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: todoController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: TextStyle(
                                        color: _isDone == 1
                                            ? kPrimaryColor
                                            : kDarkColor.withOpacity(0.6),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Add a todo to this task...",
                                        hintMaxLines: 2,
                                        errorText: _todoValidate
                                            ? "Type an activity here"
                                            : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
//                                  GestureDetector(
//                                    child: Container(
//                                      height: 30.0,
//                                      width: 30.0,
//                                      decoration: BoxDecoration(
//                                          color: kDarkColor,
//                                          borderRadius:
//                                          BorderRadius.circular(10.0)),
//                                      child: Icon(
//                                        Icons.watch,
//                                        color: kLiteColor,
//                                      ),
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    width: 10.0,
//                                  ),
                                  GestureDetector(
                                    onTap: ()  {
                                      saveTodoToDatabase();
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                          color: kDarkColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Icon(
                                        Icons.add,
                                        color: kLiteColor,
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
