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

  Map<String, dynamic> toMap() => {
    "todoId": todoId,
    "todoTitle": todoTitle,
    "isDone": todoIsDone,
    "taskId" : taskId
  };
}
