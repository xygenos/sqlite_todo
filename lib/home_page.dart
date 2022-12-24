// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'add_todo.dart';
import 'todos.dart';
import 'todo_helper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQ lite Todo'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: DBHelper.readTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Loading Todos...'),
                ],
              ),
            );
          }
          return snapshot.data!.isEmpty ? const Center(
            child: Text('There are no current todos, add some?'),
          ):
          ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final todos = snapshot.data![index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                onDismissed: (direction) async {
                  await DBHelper.deleteTodos(todos.id!);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todo deleted'),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(todos.name),
                  subtitle: Text(todos.todo),
                  onTap: () async {
                    final refresh = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AddTodos(
                          todo: Todo(
                            id: todos.id,
                            name: todos.name,
                            todo: todos.todo,
                          ),
                        )
                        )
                    );
                    if (refresh) {
                      setState(() {});
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final refresh = await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddTodos()));
          if (refresh) {
            setState(() {
            }
            );
          }
        },
      ),
    );
  }
}
