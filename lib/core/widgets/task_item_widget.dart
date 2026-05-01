import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';
import 'package:tasky_app/screens/edit_task_screen.dart' show EditTaskScreen;

import '../utils/firebase_utils.dart';


class TaskItem extends StatelessWidget {
  final Map<String, dynamic> taskData;
  final String taskId;

  const TaskItem({super.key, required this.taskData, required this.taskId});

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(taskData['date']);
    String formattedDate = DateFormat('dd/MM/yyyy At HH:mm').format(date);

    bool isDone = taskData['isDone'] ?? false;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(
              taskData: taskData,
              taskId: taskId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                FirebaseUtils.updateTaskStatus(taskId, !isDone);
              },
              child: Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: ColorsManager.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskData['title'] ?? "",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsManager.textLargeColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Image.asset(AssetsManager.flag, width: 14, height: 14),
                  const SizedBox(width: 4),
                  Text(
                    "${taskData['priority']}",
                    style: const TextStyle(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}