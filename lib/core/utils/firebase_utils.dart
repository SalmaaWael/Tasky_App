import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static Future<void> addTaskToFirestore({
    required String title,
    required String description,
    required DateTime date,
    required int priority,
  }) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      CollectionReference tasksRef = FirebaseFirestore.instance.collection('tasks');

      await tasksRef.add({
        'userId': uid,
        'title': title,
        'description': description,
        'date': date.millisecondsSinceEpoch,
        'priority': priority,
        'isDone': false,
      });
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTasksStream() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }

  static Future<void> updateTaskStatus(String taskId, bool isDone) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'isDone': isDone,
    });
  }

  static Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update(data);
  }

  // خليناها static وجوه الكلاس
  static Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  }
}