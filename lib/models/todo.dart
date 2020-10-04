import 'package:flutter/material.dart';

class Todo {
  Todo({
    this.todoId,
    this.todoTitle,
    this.todoIsDone,
    this.taskId,
    this.deadlineDate,
    this.deadlineDateTime,
  });

  int todoId;
  String todoTitle;
  int todoIsDone;
  int taskId;
  String deadlineDate;
  String deadlineTime;
  String deadlineDateTime;

  Map<String, dynamic> toMap() => {
    "todoId": todoId,
    "todoTitle": todoTitle,
    "isDone": todoIsDone,
    "taskId" : taskId,
    "deadlineDateTime" : deadlineDateTime,
  };
}
