class Todo {
  final int id;
  final String title;
  final bool isCompleted;
  final String? dueDate;
  final String? notes;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.dueDate,
    this.notes,
  });
}
