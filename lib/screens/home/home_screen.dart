import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../../core/utils/firebase_utils.dart';
import '../../core/widgets/task_item_widget.dart';
import '../../widgets/add_task_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          AssetsManager.logoo,
          height: 30,
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Image.asset(
              AssetsManager.logout,
              color: const Color(0xffFF3951),
              width: 24,
              height: 24,
            ),
            label: const Text(
              "Log out",
              style: TextStyle(
                  color: Color(0xffFF3951),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search for your task...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: ColorsManager.primaryColor),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorsManager.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 90,
              child: DatePicker(
                DateTime.now().subtract(const Duration(days: 3)),
                initialSelectedDate: selectedDate,
                selectionColor: ColorsManager.primaryColor,
                selectedTextColor: Colors.white,
                dateTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.textLargeColor,
                ),
                dayTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
                monthTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                onDateChange: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseUtils.getTasksStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: ColorsManager.primaryColor));
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong!"));
                  }

                  var tasksDocs = snapshot.data?.docs ?? [];

                  var filteredTasks = tasksDocs.where((doc) {
                    var data = doc.data();
                    bool matchesSearch = data['title'].toString().toLowerCase().contains(searchQuery.toLowerCase());
                    DateTime taskDate = DateTime.fromMillisecondsSinceEpoch(data['date']);
                    bool matchesDate = taskDate.year == selectedDate.year &&
                        taskDate.month == selectedDate.month &&
                        taskDate.day == selectedDate.day;
                    return matchesSearch && matchesDate;
                  }).toList();

                  var todoTasks = filteredTasks.where((doc) => doc.data()['isDone'] != true).toList();
                  var completedTasks = filteredTasks.where((doc) => doc.data()['isDone'] == true).toList();

                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AssetsManager.homeImage, width: 250),
                          const SizedBox(height: 16),
                          const Text("What do you want to do today?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Tap + to add your tasks", style: TextStyle(color: Colors.grey.shade500)),
                        ],
                      ),
                    );
                  }


                  List<Widget> listItems = [];

                  listItems.addAll(
                      todoTasks.map((doc) => TaskItem(
                        taskData: doc.data(),
                        taskId: doc.id,
                      )).toList()
                  );

                  if (completedTasks.isNotEmpty) {
                    listItems.add(
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 12),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.textLargeColor,
                          ),
                        ),
                      ),
                    );

                    listItems.addAll(
                        completedTasks.map((doc) => TaskItem(
                          taskData: doc.data(),
                          taskId: doc.id,
                        )).toList()
                    );
                  }

                  return ListView(
                    children: listItems,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskBottomSheet(context);
        },
        backgroundColor: ColorsManager.textLargeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.add,
          color: ColorsManager.primaryColor,
          size: 32,
        ),
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return const AddTask();
      },
    );
  }
}