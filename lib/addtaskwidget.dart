import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import './workscreen.dart';
import './database.dart';

class AddTaskWidget extends StatefulWidget {
  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  static final DateFormat formatter = DateFormat('dd/MM/yyy');
  final taskNameController = TextEditingController();
  final taskDueDateController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  String hintSettingString = "DD/MM/YYYY";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () async {
              String taskName = taskNameController.text;
              print("Name:$taskName");
              String taskDueDate = hintSettingString;
              String taskDescription = taskDescriptionController.text;
              Map returningValue = {
                "Task Name": taskName,
                "Task Due Date": taskDueDate,
                "Task Description": taskDescription,
                "Is Completed": "false"
              };
              // Random random = new Random();
              // int randomNumber = random.nextInt(10000);
              // String taskId = taskName + "NUM" + randomNumber.toString();
              // Adding to database
              String taskId = taskName;
              if (taskName != "") {
                if (taskDueDate != "") {
                  await FirebaseFirestore.instance
                      .collection("taskData")
                      .doc(taskId)
                      .set({
                    "Task Name": taskName,
                    "Task Due Date": taskDueDate,
                    "Task Description": taskDescription,
                    "Is Completed": "false",
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkScreen(
                        returningValue,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: "Enter a valid due date");
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Not all fields have been entered!!!");
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true, minTime: DateTime.now(),
                  //maxTime: DateTime(2019, 6, 7),
                  onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                formatter.format(date);
                setState(() {
                  hintSettingString = formatter.format(date);
                });
              }, currentTime: DateTime.now());
            },
          ),
        ],
        title: Text("Add A Task"),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Wrap(
        children: [
          Column(
            children: [
              Text("SPACE"),
              Text("SPACE"),
              Text("SPACE"),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Task Name:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Divider(),
              TextField(
                controller: taskNameController,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 5.0),
                  ),
                  border: InputBorder.none,
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Divider(),
              Divider(),
              Divider(
                color: Colors.red,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Task Due Date:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Divider(),
              TextField(
                controller: taskDueDateController,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 5.0),
                  ),
                  border: InputBorder.none,
                  hintText: hintSettingString,
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Divider(),
              Divider(),
              Divider(
                color: Colors.red,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Task Description:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Divider(),
              TextField(
                controller: taskDescriptionController,
                maxLines: 10,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 5.0),
                  ),
                  border: InputBorder.none,
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
