import 'package:flutter/material.dart';
import '../models/task.dart';
import 'subtask_tile.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(Task) onUpdate;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isExpanded = false;

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