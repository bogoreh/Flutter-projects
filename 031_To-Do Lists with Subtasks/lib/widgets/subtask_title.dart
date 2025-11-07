import 'package:flutter/material.dart';
import '../models/subtask.dart';

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