import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';

import '../core/utils/firebase_utils.dart';
import '../core/widgets/priority_dialog.dart' show PriorityDialog;
import '../core/widgets/task_text_feild.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime? selectedDate;
  int selectedPriority = 1;

  var titleController = TextEditingController();
  var descController = TextEditingController();

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorsManager.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _pickPriority() {
    showDialog(
      context: context,
      builder: (context) => PriorityDialog(
        initialPriority: selectedPriority,
        onPrioritySelected: (newPriority) {
          setState(() {
            selectedPriority = newPriority;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          TaskTextField(
            controller: titleController,
            hintText: "Do math homework",
          ),
          const SizedBox(height: 12),

          TaskTextField(
            controller: descController,
            hintText: "Description",
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (selectedDate != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: ColorsManager.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    DateFormat('dd MMM').format(selectedDate!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: ColorsManager.primaryColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                  Image.asset(
                  AssetsManager.flag,
                  width: 16,
                  height: 16,
                ),
                    const SizedBox(width: 6),
                    Text(
                      "$selectedPriority",
                      style: const TextStyle(
                        color: ColorsManager.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                icon: Image.asset(AssetsManager.timer, width: 24, height: 24),
                onPressed: _pickDate,
              ),
              IconButton(
                icon: Image.asset(AssetsManager.flag, width: 24, height: 24),
                onPressed: _pickPriority,
              ),
              const Spacer(),
              IconButton(
                icon: Image.asset(AssetsManager.send, width: 24, height: 24),
                onPressed: () async {
                  if (titleController.text.trim().isEmpty || descController.text.trim().isEmpty) {
                    return;
                  }
                  if (selectedDate == null) {
                    return;
                  }

                  await FirebaseUtils.addTaskToFirestore(
                    title: titleController.text.trim(),
                    description: descController.text.trim(),
                    date: selectedDate!,
                    priority: selectedPriority,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}