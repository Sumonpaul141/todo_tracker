import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotrack/utils/database.dart';

class AlertDialogs{
  DatabaseManager databaseManager;



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

  Future<void> showDialogSingleTaskUpdate(BuildContext context, int todoId, String todoTitle, String todoDesc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: todoTitle
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: todoDesc
                  ),
                ),
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

}
