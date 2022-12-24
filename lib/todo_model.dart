class Todo {
  int? id;
  String name;
  String todo;

  Todo({this.id, required this.name, required this.todo});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    name: json['name'],
    todo: json['todo'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'todo': todo,
  };
}
