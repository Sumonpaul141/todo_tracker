class Todo {
  Todo({
    this.todoId,
    this.todoTitle,
    this.todoIsDone,
    this.taskId,
  });

  int todoId;
  String todoTitle;
  int todoIsDone;
  int taskId;

  Map<String, dynamic> toJson() => {
    "todoId": todoId,
    "todoTitle": todoTitle,
    "todoIsDone": todoIsDone,
    "taskId" : taskId
  };
}
