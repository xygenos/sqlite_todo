// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'todos.dart';
import 'todo_helper.dart';

class AddTodos extends StatefulWidget {

  const AddTodos({Key? key, this.todo}) : super(key: key);
  final Todo? todo;

  @override
  State<AddTodos> createState() => _AddTodosState();
}

class _AddTodosState extends State<AddTodos> {

  final _nameController = TextEditingController();
  final _todoController = TextEditingController();

  @override
  void initState() {
    if (widget.todo != null) {
      _nameController.text = widget.todo!.name;
      _todoController.text = widget.todo!.todo;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTextFormField(
                _nameController,
                'Title',
              ),
              const SizedBox(
                height: 30,
              ),
              _buildTextFormField(
                _todoController,
                'Description',
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                    if (widget.todo != null) {
                      final todo = Todo(
                        id: widget.todo!.id,
                        name: _nameController.text,
                        todo: _todoController.text,
                      );
                      await DBHelper.updateTodos(todo);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Todo updated'),
                        ),
                      );
                      Navigator.of(context).pop(true);
                    } else {
                      final todo = Todo(
                        name: _nameController.text,
                        todo: _todoController.text,
                      );
                      await DBHelper.createTodos(todo);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Todo added'),
                        ),
                      );
                      Navigator.of(context).pop(true);
                    }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  TextFormField _buildTextFormField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
