import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/database_provider.dart';
import '../models/todo.dart';

class EditTodoScreen extends StatelessWidget {
  final Todo todo;

  EditTodoScreen({required this.todo});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = todo.title;
    _notesController.text = todo.notes ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Notes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<DatabaseProvider>(context, listen: false)
                    .updateTodoTitle(todo.id, _titleController.text);
                Provider.of<DatabaseProvider>(context, listen: false)
                    .updateTodoNotes(todo.id, _notesController.text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
