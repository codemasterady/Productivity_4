import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Global Variables
  TextEditingController userNameController =
      TextEditingController(); // Controller for username
  TextEditingController dailyStepsGoalController = TextEditingController();
  TextEditingController dailyCaloriesGoalController = TextEditingController();
  TextEditingController dailySleepGoalController = TextEditingController();
  String userName; // Variable that holds username
  String dailyStepsGoal;
  String dailyCaloriesGoal;
  String dailySleepGoal;

  // Global Functions

  // Function that sets the values updated for the shared preferences
  Future setValuesToSharedPrefferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Part 1 - USERNAME
    // Getting the username from the text controller
    String userName = userNameController.text;
    // Getting the Steps Tracker from the text controller
    String dailyStepsGoal = dailyStepsGoalController.text;
    // Getting the Calories Tracker from the text controller
    String dailyCaloriesGoal = dailyCaloriesGoalController.text;
    // Getting the Sleep Tracker from the text controller
    String dailySleepGoal = dailySleepGoalController.text;
    // Setting the username
    if (userName != "") {
      prefs.setString("User Name", userName);
    }
    print("Username: $userName Set");
    // Setting the Steps target
    if (dailyStepsGoal != "") {
      prefs.setInt("Steps Target", int.parse(dailyStepsGoal));
    }
    // Setting the calories target
    if (dailyCaloriesGoal != "") {
      prefs.setInt("Caloric Target", int.parse(dailyCaloriesGoal));
    }
    // Setting the sleep target
    if (dailySleepGoal != "") {
      prefs.setInt("Sleep Target", int.parse(dailySleepGoal));
    }

    // Setting the toast
    Fluttertoast.showToast(msg: "New Settings Saved");
  }

  // Function that gets the username for the hint
  Future<String> getUserNameForHint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("User Name").toString();
  }

  // Function that gets the steps for the hint
  Future<String> getStepsGoalForHint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("Steps Target").toString();
  }

  // Function that gets the calories for the hint
  Future<String> getCaloriesGoalForHint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("Caloric Target").toString();
  }

  // Function that gets the calories for the hint
  Future<String> getSleepGoalForHint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("Sleep Target").toString();
  }

  @override
  Widget build(BuildContext context) {
    // Getting the username for hint
    getUserNameForHint().then((value) {
      setState(() {
        userName = value;
      });
    });
    // Getting the steps goal
    getStepsGoalForHint().then((value) {
      setState(() {
        dailyStepsGoal = value;
      });
    });
    getCaloriesGoalForHint().then((value) {
      setState(() {
        dailyCaloriesGoal = value;
      });
    });
    getSleepGoalForHint().then((value) {
      setState(() {
        dailySleepGoal = value;
      });
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Settings"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.save_alt,
                color: Colors.white,
              ),
              onPressed: setValuesToSharedPrefferences),
        ],
      ),
      body: ListView(
        children: [
          Text("SPACE"),
          Text(
            "Username:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("SPACE"),
          TextField(
            controller: userNameController,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purpleAccent,
                  width: 5.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 5.0),
              ),
              border: InputBorder.none,
              hintText: userName,
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Divider(
            color: Colors.red,
          ),
          Divider(
            color: Colors.pink,
          ),
          Divider(
            color: Colors.lightBlueAccent,
          ),
          Text(
            "Digital Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text(
            "Daily Sleep Goal:",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("SPACE"),
          TextField(
            controller: dailySleepGoalController,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 5.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 5.0),
              ),
              border: InputBorder.none,
              hintText: dailySleepGoal,
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Divider(
            color: Colors.greenAccent,
          ),
          Text(
            "Health Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text(
            "Daily Steps Goal:",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("SPACE"),
          TextField(
            controller: dailyStepsGoalController,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                  width: 5.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 5.0),
              ),
              border: InputBorder.none,
              hintText: dailyStepsGoal,
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text(
            "Daily Calories Goal:",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("SPACE"),
          TextField(
            controller: dailyCaloriesGoalController,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                  width: 5.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 5.0),
              ),
              border: InputBorder.none,
              hintText: dailyCaloriesGoal,
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
