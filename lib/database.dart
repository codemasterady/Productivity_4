import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  // Initializing the unique id
  final String uid;
  DatabaseService({this.uid});

  // Collection initialization
  final CollectionReference workTaskCollection =
      Firestore.instance.collection('Work Task Collection');

  // Methords to update the database

  // Updating a task
  Future updateWorkTasks(
      String name, String dueDate, String description, String completed) async {
    return await workTaskCollection.document(uid).setData({
      "Task Name": name,
      "Task Due Date": dueDate,
      "Task Description": description,
      "Is Completed": completed,
    });
  }
}
