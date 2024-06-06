import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/database_provider.dart';
import '../screens/notes_screen.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;

  TodoListItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (bool? value) {
          Provider.of<DatabaseProvider>(context, listen: false)
              .updateTodoStatus(todo.id, value ?? false);
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          Provider.of<DatabaseProvider>(context, listen: false)
              .deleteTodo(todo.id);
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotesScreen(todo: todo),
          ),
        );
      },
    );
  }
}
