import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './workscreentaskcard.dart';
import './addtaskwidget.dart';
import './main.dart';
import './workscreenchecker.dart';

class WorkScreen extends StatefulWidget {
  Map featureMap;
  WorkScreen(this.featureMap);
  @override
  _WorkScreenState createState() => _WorkScreenState(featureMap);
}

class _WorkScreenState extends State<WorkScreen> {
  // Global Variables (COnstructor)
  double workProgress = 0.5;
  // int x = 7;
  bool showWholeList = false;
  Icon showWholeListIcon = Icon(Icons.expand_more);
  List widgetsToBeDisplayed;
  bool valueLoadedFromDatabase = false;
  List traitsThatWereDisplayed;
  List<Widget> listOfCardWidgets;
  bool isTaskAdded = false;
  List listOfCards = [];
  Color workProgressIndicatorColor = Colors.red;
  Map featureMap;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyy');
  final String formattedDate = formatter.format(now);
  _WorkScreenState(this.featureMap);
  // List of Maps containing all the values
  List _tasks = [
    {
      "Task Name": "Code The App",
      "Task Due Date": "14/09/2020",
      "Is Completed": "false"
    },
    {
      "Task Name": "Submit Application",
      "Task Due Date": "21/10/2020",
      "Is Completed": "false"
    },
    {
      "Task Name": "Do Project",
      "Task Due Date": "21/08/2020",
      "Is Completed": "true"
    },
    {
      "Task Name": "Finish Interview",
      "Task Due Date": "21/09/2020",
      "Is Completed": "false"
    }
  ];

  // Functions

  // Function to convert the list of traits to a card
  List<Widget> traitToListConverter(List param) {
    List<Widget> returnValue = [];
    returnValue = [];
    int paramLength = param.length;
    for (int i = 0; i < paramLength; i++) {
      Map trait = param[i];
      Widget currentWidget = WorkScreenTaskCard(
          trait["Task Name"],
          trait["Task Due Date"],
          trait["Task Description"],
          trait["Is Completed"]);
      returnValue.add(currentWidget);
    }

    return returnValue;
  }

  // Function to get the database
  Future<List> gettingListOfCard(bool showWholeList) async {
    List<Map> listOfCardTraits = [];
    List<Map> returningList = [];
    List<Map> listOfToday = [];
    List<Map> listOfTomorrow = [];
    var data = await FirebaseFirestore.instance
        .collection("taskData")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        Map dataForList = f.data();
        listOfCardTraits.add({
          "Task Name": dataForList["Task Name"],
          "Task Due Date": dataForList["Task Due Date"],
          "Task Description": dataForList["Task Description"],
          "Is Completed": dataForList["Is Completed"]
        });
        //;
      });
      //listOfCardTraits = traitToListConverter(listOfCardTraits);

      //print(listOfCardTraits);
    });
    //listOfCardTraits = traitToListConverter(listOfCardTraits);
    //print(listOfCardTraits);

    for (Map item in listOfCardTraits) {
      String newTomorrow = "";
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
      String today = formattedDate.toString();
      today = today.replaceAll("-", "/");
      // print("1" + item["Task Due Date"]);
      // print("2" + newTomorrow);
      if (item["Task Due Date"] == today) {
        // listOfCardTraits.remove(item);
        listOfToday.add(item);
      } else if (item["Task Due Date"] == tomorrow) {
        listOfTomorrow.add(item);
      }
    }

    returningList = listOfToday + listOfTomorrow;

    if (showWholeList == false) {
      return returningList.toList();
    } else {
      return listOfCardTraits.toList();
    }
  }

  // Function to add value into the shared preference
  void addTaskToSharedPrefference(Map inputMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prevSharedValues = prefs.get("Tasks");
    String seperator = "||||";
    String valueToBeAdded = inputMap["Task Name"] +
        seperator +
        inputMap["Task Due Date"] +
        seperator +
        inputMap["Task Description"] +
        seperator +
        inputMap["Is Completed"] +
        "\n";

    valueToBeAdded = prevSharedValues + valueToBeAdded;

    if (inputMap.toString() != "{}") {
      prefs.setString("Tasks", valueToBeAdded);
    }
  }

  // Function to add the map into the list of cards
  Widget addCardsOfTask(Map inputMap) {
    Widget inputValue = WorkScreenTaskCard(
      inputMap["Task Name"],
      inputMap["Task Due Date"],
      inputMap["Task Description"],
      inputMap["Is Completed"],
    );
    if (inputMap.toString() != "{}") {
      isTaskAdded = true;
    } else {
      isTaskAdded = false;
    }
    return inputValue;
  }

  // Function to sort a list based on due date
  listSorterBasedOnDueDate(List<Map> param) async {
    int currIndex = 0;
    var currList = await param;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    List<Map> listOfTodayTasks = [];
    currList.sort((m1, m2) {
      var r = m1["Task Due Date"].compareTo(m2["Task Due Date"]);
      if (r != 0) return r;
      return m1["Task Name"].compareTo(m2["Task Name"]);
    });
    // for (int i = 0; i < param.length; i++) {
    //   print("1: " + formattedDate.replaceAll("-", "/").toString());
    //   print("2: " + param[i]["Task Due Date"]);
    //   if (formattedDate.replaceAll("-", "/").toString() ==
    //       param[i]["Task Due Date"].toString()) {
    //     print("ENtered");
    //     param.remove(param[i]);
    //     listOfTodayTasks.add(param[i]);
    //   }
    // }
    //return listOfTodayTasks;
  }

  // Function that updates the progress-bar
  double progressSetter(List<Map> param) {
    double returningValue;
    int numTrue = 0;
    int numFalse = 0;
    int totalNum;
    for (Map item in param) {
      String currString = item["Is Completed"];
      String dueDate = item["Task Due Date"];
      dueDate = dueDate.split("/").join("-");

      if (formattedDate.toString() == dueDate) {
        if (currString == 'true') {
          numTrue = numTrue + 1;
        } else {
          numFalse = numFalse + 1;
        }
      }
    }
    totalNum = numTrue + numFalse;
    if (totalNum <= 0) {
      return 0;
    } else {
      returningValue = numTrue / totalNum;
      return returningValue;
    }
  }

  // Function to sort the list
  List listSorter(List param) {
    for (int i = 0; i < param.length - 2; i++) {
      print("I $i");
      if (param[i]["Task Due Date"].toString() !=
          param[i + 1]["Task Due Date"].toString()) {
        Map j = param[i];
        param[i + 1] = param[i];
        param[i] = j;
      }
    }
    return param;
  }

  // Functions to check the boc
  @override
  Widget build(BuildContext context) {
    // Getting the list of card
    gettingListOfCard(showWholeList).then((value) async {
      //widgetsToBeDisplayed = await [];
      setState(() {
        widgetsToBeDisplayed = value;

        traitsThatWereDisplayed = value;
        // Setting the progressbar
        workProgress = progressSetter(traitsThatWereDisplayed);
        widgetsToBeDisplayed = traitToListConverter(widgetsToBeDisplayed);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble("Work Progress", workProgress);
    });

    // If Statement to change color
    if (workProgress >= (0.4) && workProgress < 0.75) {
      workProgressIndicatorColor = Colors.yellow;
    } else if (workProgress >= 0.75 && workProgress < 1) {
      workProgressIndicatorColor = Colors.green;
    } else if (workProgress < 0.4) {
      workProgressIndicatorColor = Colors.red;
    } else {
      workProgressIndicatorColor = Colors.lightGreen;
    }

    //Adding card
    List<Widget> cardList = [
      WorkScreenTaskCard(
        _tasks[0]["Task Name"],
        _tasks[0]["Task Due Date"],
        "Desc",
        _tasks[0]["Is Completed"],
      ),
      WorkScreenTaskCard(
        _tasks[1]["Task Name"],
        _tasks[1]["Task Due Date"],
        "Desc",
        _tasks[1]["Is Completed"],
      ),
      WorkScreenTaskCard(
        _tasks[2]["Task Name"],
        _tasks[2]["Task Due Date"],
        "Desc",
        _tasks[2]["Is Completed"],
      ),
      WorkScreenTaskCard(
        _tasks[3]["Task Name"],
        _tasks[3]["Task Due Date"],
        "Desc",
        _tasks[3]["Is Completed"],
      ),
    ];

    // print(cardListAdder);
    // if (isTaskAdded == true) {
    //   print("Added");
    //   //addTaskToSharedPrefference(featureMap);
    //   cardList.add(cardListAdder);
    // } else {
    //   print("No Card Added");
    // }
    // Future.delayed(
    //   Duration(seconds: 1),
    // );
    // widgetsToBeDisplayed = null;
    if (widgetsToBeDisplayed != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              }),
          title: Text("Work"),
          actions: [
            IconButton(
                icon: showWholeListIcon,
                onPressed: () {
                  if (showWholeList == false) {
                    showWholeList = true;
                    Fluttertoast.showToast(msg: "Expanding List");
                    showWholeListIcon = Icon(Icons.expand_less);
                  } else {
                    showWholeList = false;
                    Fluttertoast.showToast(msg: "Reducing List");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkScreen({})));
                  }
                }),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskWidget()),
                );
              },
            ),
          ],
        ),
        resizeToAvoidBottomPadding: true,
        body: Wrap(children: [
          Column(
            children: [
              Text(
                "Your Progress: ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("SPACE"),
              Text("SPACE"),
              LinearPercentIndicator(
                width: 375,
                lineHeight: 17,
                percent: workProgress,
                animateFromLastPercent: true,
                progressColor: workProgressIndicatorColor,
                animation: true,
                animationDuration: 1000,
              ),
              Text("SPACE"),
              Text(
                "Tasks: ",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("SPACE"),
              Container(
                height: 500,
                width: 700,
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      showDialog(
                          context: context,
                          child: WorkScreenChecker(
                              traitsThatWereDisplayed, "long"));
                    });
                  },
                  onTap: () {
                    setState(() {
                      showDialog(
                          context: context,
                          child: WorkScreenChecker(
                              traitsThatWereDisplayed, "single"));
                    });
                  },
                  child: ListWheelScrollView(
                    itemExtent: 100,
                    physics: FixedExtentScrollPhysics(),
                    children: widgetsToBeDisplayed,
                    useMagnifier: true,
                    magnification: 1.0,
                  ),
                ),
                // Text("SPACE"),
                // Text("SPACE"),
                // Text("SPACE"),
                // Container(
                //   child: FloatingActionButton(
                //     backgroundColor: Colors.red,
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => AddTaskWidget()),
                //       );
                //     },
                //     child: Text(
                //       "+",
                //       style: TextStyle(
                //         fontSize: 20,
                //       ),
                //     ),
                //   ),
                //   alignment: Alignment.bottomRight,
                // )
              ),
            ],
            mainAxisSize: MainAxisSize.max,
          ),
        ]),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Communicating With \nThe Servers (☁)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Text("SPACE"),
              Text("SPACE"),
              Text("SPACE"),
              SpinKitFadingCube(
                color: Colors.red,
              ),
            ],
          ),
        ),
      );
    }
  }
}
