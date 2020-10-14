import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotrack/models/task.dart';
import 'package:todotrack/utils/database.dart';
import 'package:todotrack/values/contants.dart';
import 'dart:async';

class AlertDialogs{
  DatabaseManager databaseManager;
  static TextEditingController titleCont;
  static TextEditingController descCont;

  static void init(){
    titleCont = TextEditingController();
    descCont = TextEditingController();
  }
  static void dispose(){
    titleCont.dispose();
    descCont.dispose();
  }
   Future<void> showDialogForTotalTaskDelete(BuildContext context, int taskId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('This task will be deleted..!!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete the whole task? This cannot be undone. Make sure before deleting...'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                databaseManager = DatabaseManager();
                await databaseManager
                    .deleteTask(taskId)
                    .then((value) {
                  Navigator.pop(context);
                }).then((value) {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: Text('Ow NO!!'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialogSingleTodoDelete(BuildContext context, int todoId, String todoTitle) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete ($todoTitle)'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                databaseManager = DatabaseManager();
                await databaseManager
                    .deleteTodo(todoId)
                    .then((value) {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: Text('Ow NO!!'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialogSingleTaskUpdate(BuildContext context, int taskId, String taskTitle, String taskDesc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          title: Text("Edit your task"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleCont..text = taskTitle,
                ),
                TextField(
                  controller: descCont..text = taskDesc,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              textColor: kPrimaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              color: kPrimaryColor,
              textColor: kLiteColor,
              child: Text('Update'),
              onPressed: () async {
                databaseManager = DatabaseManager();
                var updateTitle, updateDesc;
                if(titleCont.value.text.toString() == "" || titleCont.value.text.toString() == null){
                  updateTitle = taskTitle;
                }else{
                  updateTitle = titleCont.value.text.toString();
                }
                if(descCont.value.text.toString() == "" || descCont.value.text.toString() == null){
                  updateDesc = taskDesc;
                }else{
                  updateDesc = descCont.value.text.toString();
                }
                await databaseManager
                    .updateTaskDone(taskId, updateTitle, updateDesc)
                    .then((value){
                  Navigator.pop(context);
                });

              },
            ),
          ],
        );
      },
    );
  }
}

