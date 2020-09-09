// To parse this JSON data, do

class Task {
  int taskId;
  String taskTitle;
  String taskDescription;

  Task({
    this.taskId,
    this.taskTitle,
    this.taskDescription,
  });

  Map<String, dynamic> toMap() => {
    "taskId": taskId,
    "taskTitle": taskTitle,
    "taskDescription": taskDescription,
  };
}