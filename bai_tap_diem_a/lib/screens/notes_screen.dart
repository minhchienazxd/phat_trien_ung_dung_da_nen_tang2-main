import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'edit_todo_screen.dart';

class NotesScreen extends StatelessWidget {
  final Todo todo;

  NotesScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${todo.title}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Notes: ${todo.notes}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTodoScreen(todo: todo),
                  ),
                );
              },
              child: Text('Edit Notes'),
            ),
          ],
        ),
      ),
    );
  }
}
