import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/database_provider.dart';
import 'settings_screen.dart';
import '../widgets/todo_list_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('To-Do List'),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  _showFilterMenu(context, provider);
                },
              ),
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  _showSortMenu(context, provider);
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: FutureBuilder<List<Todo>>(
            future: provider.getTodos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final todos = snapshot.data!;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoListItem(todo: todo);
                  },
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController _titleController = TextEditingController();
                  final TextEditingController _notesController = TextEditingController();
                  DateTime? _selectedDate;
                  return AlertDialog(
                    title: Text('Thêm công việc mới'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(hintText: 'Nhập tiêu đề'),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _notesController,
                          decoration: InputDecoration(hintText: 'Nhập ghi chú'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              _selectedDate = picked;
                            }
                          },
                          child: Text('Chọn ngày đến hạn'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          provider.addTodo(
                            _titleController.text,
                            _selectedDate != null ? _selectedDate.toString() : '',
                            _notesController.text,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('Thêm'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Hủy'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showFilterMenu(BuildContext context, DatabaseProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Show Completed Tasks'),
                trailing: Switch(
                  value: provider.isCompletedFilter,
                  onChanged: (value) {
                    provider.toggleCompletedFilter();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortMenu(BuildContext context, DatabaseProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Sort by Title Ascending'),
                trailing: Switch(
                  value: provider.sortByTitleAscending,
                  onChanged: (value) {
                    provider.toggleSortByTitleAscending();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
