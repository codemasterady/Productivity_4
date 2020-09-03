import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './settingspage.dart';
import './homeCard.dart';
import './workscreen.dart';

void main() async {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State {
  // Global Variables
  String greetingStatement;
  String userName;
  double workProgress = 0;
  double relationshipsProgress = 0.1; // Dont change 4 of em
  double digitalProgress = 0.1;
  double healthProgress = 0.1;
  // Function to navigate to the 4 basic screens
  void goToWork() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return WorkScreen({});
    }));
  }

  void goToSocial() {}
  void goToDigital() {}
  void goToHealth() {}

  // Functions for ling press
  void goToWorkLong() {
    print("hi");
  }

  void goToSocialLong() {}
  void goToDigitalLong() {}
  void goToHealthLong() {}
  void stateDeterminerUsingTime() {
    // Function that calculates the time and returns a statement
    String nowInfo = DateFormat.yMEd().add_jms().format(DateTime.now());
    List<String> splitNowInfo = nowInfo.split(" ");
    String typeOfDay = splitNowInfo[3];
    if (typeOfDay == "AM") {
      greetingStatement = "Good Morning";
    } else {
      greetingStatement = "Good Evening";
    }
  }

  // Function that loads the username
  Future<String> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString("User Name");
    return userName.toString();
  }

  // Function to get the shared prefferences
  Future<double> getWorkProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("Work Progress").toDouble();
  }

  Widget build(BuildContext context) {
    loadUserName().then((value) async {
      // await getWorkProgress().then((value) {
      //   workProgress = value;
      // });
      setState(() {
        userName = value;
      });
    });
    stateDeterminerUsingTime();
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            greetingStatement + " " + userName.toString() + " !!!",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            )
          ],
        ),
        body: Column(children: <Widget>[
          Row(
            children: <Widget>[
              CircularPercentIndicator(
                radius: 80,
                percent: workProgress,
                progressColor: Colors.red,
                animation: true,
                animationDuration: 2000,
                center: Text(
                  "W",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(flex: 1),
              CircularPercentIndicator(
                radius: 80,
                percent: relationshipsProgress,
                progressColor: Colors.pink,
                animation: true,
                animationDuration: 2000,
                center: Text("S",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Spacer(flex: 1),
              CircularPercentIndicator(
                radius: 80,
                percent: digitalProgress,
                progressColor: Colors.lightBlue,
                animation: true,
                animationDuration: 2000,
                center: Text("D",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Spacer(flex: 1),
              CircularPercentIndicator(
                radius: 80,
                percent: healthProgress,
                progressColor: Colors.lightGreen,
                animation: true,
                animationDuration: 2000,
                center: Text("H",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          Divider(
            color: Colors.white,
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text("SPACE"),
          Text("SPACE"),

          Row(
            children: [
              HomeCard("Work", Colors.red, "None", goToWork, goToWorkLong),
              Spacer(),
              HomeCard(
                  "Social", Colors.pink, "None", goToSocial, goToSocialLong),
            ],
          ),
          // Spacer(),
          Text("SPACE"),
          Text("SPACE"),
          Row(
            children: [
              HomeCard(
                  "Digital", Colors.blue, "None", goToDigital, goToDigitalLong),
              Spacer(),
              HomeCard(
                  "Health", Colors.green, "None", goToHealth, goToHealthLong),
            ],
          ),
          Spacer(),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                ),
                title: Text("Journal")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.report,
                ),
                title: Text("Today's Report"))
          ],
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
