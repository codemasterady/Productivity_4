import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class WorkScreenTaskCard extends StatefulWidget {
  // Paramaters
  String taskName;
  String taskDueDate;
  String taskDescription;
  String isCompleted;

  // Constructor
  WorkScreenTaskCard(
      this.taskName, this.taskDueDate, this.taskDescription, this.isCompleted);

  @override
  WorkScreenTaskCardState createState() => WorkScreenTaskCardState(
      taskName, taskDueDate, taskDescription, isCompleted);
}

class WorkScreenTaskCardState extends State<WorkScreenTaskCard> {
  // Paramaters
  String taskName;
  String taskDueDate;
  String taskDescription;
  String isCompleted;
  Color textColorForTask;
  // Constructor
  WorkScreenTaskCardState(
    this.taskName,
    this.taskDueDate,
    this.taskDescription,
    this.isCompleted,
  );
  bool strToBoolConverter(String value) {
    if (value == "true") {
      return true;
    } else {
      return false;
    }
  }

  // Function that returns color depending on due date
  Color colorAssigner(String param) {
    String newTomorrow = "";
    param = param.split("/").join("-");
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    var yesterDayString = Jiffy()
      ..add(days: 1)
      ..startOf(Units.DAY);
    yesterDayString.format("dd-MM-yyyy");
    String yesterday = yesterDayString.dateTime.toString();
    for (int i = 0; i < 10; i++) {
      String currElement = yesterday[i];
      newTomorrow = newTomorrow + currElement;
    }
    newTomorrow = newTomorrow.split("-").join("/").toString();
    List newTomorrowSplit = newTomorrow.split("/");
    String day = newTomorrowSplit[2];
    String year = newTomorrowSplit[0];
    newTomorrowSplit[2] = year;
    newTomorrowSplit[0] = day;
    String tomorrow = newTomorrowSplit.join("/");
    tomorrow = tomorrow.toString();
    String formattedParam = param.replaceAll("-", "/");
    if (formattedParam == tomorrow.toString()) {
      return Colors.yellowAccent;
    } else if (param == formattedDate.toString()) {
      return Colors.greenAccent;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Assigning text color depending on todays date
    textColorForTask = colorAssigner(taskDueDate);
    return GestureDetector(
      onTap: () {
        print("hell");
      },
      child: Row(
        children: [
          Container(
            height: 1000,
            child: Checkbox(
              activeColor: Colors.red,
              value: strToBoolConverter(isCompleted),
              onChanged: (bool value) {
                if (value == true) {
                  isCompleted = "false";
                } else {
                  isCompleted = "true";
                }
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                //topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                //bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Colors.white,
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.red,
            height: 1000,
            width: 239,
            child: Text(
              taskName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                //topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                //bottomLeft: Radius.circular(10),
              ),
            ),
            height: 1000,
            width: 80,
            child: Text(
              "Due Date: $taskDueDate",
              style: TextStyle(color: textColorForTask),
            ),
          )
        ],
      ),
    );
  }
}
