import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';
import 'package:tasky_app/core/utils/firebase_utils.dart';
import 'package:tasky_app/core/widgets/priority_dialog.dart';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> taskData;
  final String taskId;

  const EditTaskScreen({super.key, required this.taskData, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late DateTime selectedDate;
  late int selectedPriority;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.taskData['title']);
    descController = TextEditingController(text: widget.taskData['description']);
    selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.taskData['date']);
    selectedPriority = widget.taskData['priority'];
  }

  void _openPriorityDialog() {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: ColorsManager.grey,
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.close, color: Colors.red, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  widget.taskData['isDone'] == true
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: ColorsManager.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: titleController,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: TextField(
                controller: descController,
                style: const TextStyle(color: ColorsManager.textSmallColor),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 30),

            _buildEditRow(AssetsManager.timer, "Task Time :",
                DateFormat('dd MMM').format(selectedDate), () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                }),

            const SizedBox(height: 20),

            _buildEditRow(AssetsManager.flag, "Task Priority :", "$selectedPriority", () {
              _openPriorityDialog();
            }),

            const SizedBox(height: 30),

            InkWell(
              onTap: () async {
                await FirebaseUtils.deleteTask(widget.taskId);
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 12),
                  Text("Delete Task", style: TextStyle(color: Colors.red, fontSize: 16)),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseUtils.updateTask(widget.taskId, {
                    'title': titleController.text,
                    'description': descController.text,
                    'date': selectedDate.millisecondsSinceEpoch,
                    'priority': selectedPriority,
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Edit Task",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditRow(String icon, String title, String value, VoidCallback onTap) {
    return Row(
      children: [
        Image.asset(icon, width: 24, height: 24),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 16, color: ColorsManager.textLargeColor)),
        const Spacer(),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: ColorsManager.grey, borderRadius: BorderRadius.circular(8)),
            child: Text(value, style: const TextStyle(color: ColorsManager.textSmallColor)),
          ),
        ),
      ],
    );
  }
}