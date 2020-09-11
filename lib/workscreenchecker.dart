import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import './workscreen.dart';

class WorkScreenChecker extends StatelessWidget {
  // GLobal Variables
  List paramater;
  String mode;
  WorkScreenChecker(this.paramater, this.mode);
  List<Widget> listOfTaskButtons = [];
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyy');
  final String formattedDate =
      formatter.format(now).toString().replaceAll("-", "/");

  // Global Functions

  // Function that updates wether values are checked
  Future checkTheTask(String taskName, String taskDueDate,
      String taskDescription, String isCompleted) async {
    await FirebaseFirestore.instance
        .collection("taskData")
        .doc("taskName")
        .set({
      "Task Name": taskName,
      "Task Due Date": taskDueDate,
      "Task Description": taskDescription,
      "Is Completed": "true",
    });
    print("Values Set");
  }

  // Function to list buttons
  List<Widget> listToListOfButtonsConverter(
      List param, Function buttonFunction) {
    List<Widget> listOfWidgets = [];
    for (Map task in param) {
      String taskName = task["Task Name"];
      String taskDueDate = task["Task Due Date"];
      String taskDescription = task["Task Description"];
      String isCompleted = task["Is Completed"];
      Widget taskNameButton = RaisedButton(
        onPressed: () async {
          if (mode == "long") {
            await FirebaseFirestore.instance
                .collection("taskData")
                .doc(taskName)
                .delete();
          } else {
            await FirebaseFirestore.instance
                .collection("taskData")
                .doc(taskName)
                .set({
              "Task Name": taskName,
              "Task Due Date": taskDueDate,
              "Task Description": taskDescription,
              "Is Completed": "true",
            });
          }
          buttonFunction();

          print(taskName);
        },
        child: Text(
          taskName,
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.red,
      );
      listOfWidgets.add(taskNameButton);
    }
    return listOfWidgets;
  }

  @override
  Widget build(BuildContext context) {
    listOfTaskButtons = listToListOfButtonsConverter(paramater, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkScreen({}),
        ),
      );
    });
    if (mode == "single") {
      return SimpleDialog(
        backgroundColor: Colors.white,
        title: const Text('Select Task That Was Completed:'),
        children: listOfTaskButtons,
      );
    } else if (mode == "long") {
      return SimpleDialog(
        backgroundColor: Colors.white,
        title: const Text('Select Task To Be Deleted:'),
        children: listOfTaskButtons,
      );
    }
  }
}
