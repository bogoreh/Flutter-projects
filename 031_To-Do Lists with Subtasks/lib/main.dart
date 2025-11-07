import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class SubTask {
  String id;
  String title;
  bool isCompleted;

  SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  SubTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Task {
  String id;
  String title;
  String? description;
  DateTime createdAt;
  bool isCompleted;
  List<SubTask> subTasks;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.isCompleted = false,
    this.subTasks = const [],
  });

  int get completedSubTasksCount {
    return subTasks.where((subTask) => subTask.isCompleted).length;
  }

  double get progress {
    if (subTasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    return completedSubTasksCount / subTasks.length;
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isCompleted,
    List<SubTask>? subTasks,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      subTasks: subTasks ?? this.subTasks,
    );
  }
}

class SubTaskTile extends StatelessWidget {
  final SubTask subTask;
  final Function(bool?) onChanged;
  final VoidCallback onDelete;

  const SubTaskTile({
    Key? key,
    required this.subTask,
    required this.onChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Checkbox(
          value: subTask.isCompleted,
          onChanged: onChanged,
          activeColor: Color(0xFF6C63FF),
        ),
        title: Text(
          subTask.title,
          style: TextStyle(
            fontSize: 14,
            decoration: subTask.isCompleted ? TextDecoration.lineThrough : null,
            color: subTask.isCompleted ? Color(0xFF718096) : Color(0xFF2D3748),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, size: 20),
          onPressed: onDelete,
          color: Color(0xFFF56565),
        ),
        minLeadingWidth: 0,
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final Function(Task) onUpdate;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  void _toggleSubTask(int index) {
    final updatedSubTasks = List<SubTask>.from(widget.task.subTasks);
    updatedSubTasks[index] = updatedSubTasks[index].copyWith(
      isCompleted: !updatedSubTasks[index].isCompleted,
    );
    
    widget.onUpdate(widget.task.copyWith(subTasks: updatedSubTasks));
  }

  void _deleteSubTask(int index) {
    final updatedSubTasks = List<SubTask>.from(widget.task.subTasks);
    updatedSubTasks.removeAt(index);
    
    widget.onUpdate(widget.task.copyWith(subTasks: updatedSubTasks));
  }

  void _addSubTask() {
    String newSubTaskTitle = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Subtask'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter subtask title'),
            onChanged: (value) => newSubTaskTitle = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newSubTaskTitle.trim().isNotEmpty) {
                  final newSubTask = SubTask(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: newSubTaskTitle.trim(),
                  );
                  final updatedSubTasks = List<SubTask>.from(widget.task.subTasks)..add(newSubTask);
                  
                  widget.onUpdate(widget.task.copyWith(subTasks: updatedSubTasks));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C63FF),
              ),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Checkbox(
          value: widget.task.isCompleted,
          onChanged: (value) {
            widget.onUpdate(widget.task.copyWith(isCompleted: value ?? false));
          },
          activeColor: Color(0xFF6C63FF),
        ),
        title: Text(
          widget.task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
            color: widget.task.isCompleted ? Color(0xFF718096) : Color(0xFF2D3748),
          ),
        ),
        subtitle: widget.task.description != null ? Text(
          widget.task.description!,
          style: TextStyle(color: Color(0xFF718096)),
        ) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.task.subTasks.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.task.completedSubTasksCount}/${widget.task.subTasks.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Color(0xFFF56565)),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (widget.task.subTasks.isNotEmpty) ...[
                  ...widget.task.subTasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final subTask = entry.value;
                    return SubTaskTile(
                      subTask: subTask,
                      onChanged: (_) => _toggleSubTask(index),
                      onDelete: () => _deleteSubTask(index),
                    );
                  }),
                  SizedBox(height: 8),
                ],
                OutlinedButton.icon(
                  onPressed: _addSubTask,
                  icon: Icon(Icons.add, size: 16),
                  label: Text('Add Subtask'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF6C63FF),
                    side: BorderSide(color: Color(0xFF6C63FF)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(String, String?) onSubmit;

  const AddTaskDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add New Task',
        style: TextStyle(
          color: Color(0xFF6C63FF),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Task Title',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6C63FF)),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6C63FF)),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Color(0xFF718096))),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              widget.onSubmit(
                _titleController.text.trim(),
                _descriptionController.text.trim().isEmpty 
                    ? null 
                    : _descriptionController.text.trim(),
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6C63FF),
          ),
          child: Text('Add Task'),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  void _addTask(String title, String? description) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    
    setState(() {
      _tasks.insert(0, newTask);
    });
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(onSubmit: _addTask),
    );
  }

  int get _totalTasks => _tasks.length;
  int get _completedTasks => _tasks.where((task) => task.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        actions: [
          if (_tasks.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '$_completedTasks/$_totalTasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checklist_rounded,
                    size: 80,
                    color: Color(0xFF718096).withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF718096),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first task',
                    style: TextStyle(
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskTile(
                  task: task,
                  onDelete: () => _deleteTask(task.id),
                  onUpdate: _updateTask,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Color(0xFF6C63FF),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with Subtasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D3748)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6C63FF),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}