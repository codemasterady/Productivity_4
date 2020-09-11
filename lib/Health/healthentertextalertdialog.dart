import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HealthEnterTextAlertDialog extends StatelessWidget {
  // GLobal variables
  String mode;
  String disposedText;
  String stepsTakenToday;
  String caloriesTakenToday;
  String sleepTakenToday;
  String caloriesBurntTakenToday;
  TextEditingController generalController;
  // TextEditingController stepsTakenTodayController;
  // TextEditingController caloriesTakenTodayController;
  // TextEditingController sleepTakenTodayController;
  // TextEditingController caloriesBurntTakenTodayController;
  HealthEnterTextAlertDialog(this.mode);

  // GLobal functions
  void setPrefs() async {
    // Text disposed by controller
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Checking if the recordeddate was today
    if (mode == "Steps Taken") {
      try {
        prefs.setInt("Steps Taken Today", int.parse(stepsTakenToday));
        prefs.setString("Health Recorded Data Date", formattedDate);
        Fluttertoast.showToast(msg: "$mode set");
      } catch (e) {
        Fluttertoast.showToast(msg: "Set a valid value (Integer)");
      }
    } else if (mode == "Calories Taken") {
      try {
        prefs.setInt("Calories Taken Today", int.parse(caloriesTakenToday));
        prefs.setString("Health Recorded Data Date", formattedDate);
        Fluttertoast.showToast(msg: "$mode set");
      } catch (e) {
        Fluttertoast.showToast(msg: "Set a valid value (Integer)");
      }
    } else if (mode == "Sleep Taken") {
      try {
        prefs.setInt("Sleep Taken Today", int.parse(sleepTakenToday));
        prefs.setString("Health Recorded Data Date", formattedDate);
        Fluttertoast.showToast(msg: "$mode set");
      } catch (e) {
        Fluttertoast.showToast(msg: "Set a valid value (Integer)");
      }
    } else if (mode == "Calories Burnt") {
      try {
        prefs.setInt(
            "Calories Burnt Today", int.parse(caloriesBurntTakenToday));
        prefs.setString("Health Recorded Data Date", formattedDate);
        Fluttertoast.showToast(msg: "$mode set");
      } catch (e) {
        Fluttertoast.showToast(msg: "Set a valid value (Integer)");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.green,
      children: [
        Text(
          "Enter $mode Today",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(color: Colors.green),
        TextFormField(
          onChanged: (value) {
            {
              if (mode == "Steps Taken") {
                try {
                  stepsTakenToday = value;
                } catch (e) {
                  print("Invalid");
                }
              } else if (mode == "Calories Taken") {
                caloriesTakenToday = value;
              } else if (mode == "Sleep Taken") {
                sleepTakenToday = value;
              } else if (mode == "Calories Burnt") {
                caloriesBurntTakenToday = value;
              }
            }
          },
          controller: generalController,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.greenAccent,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 5.0),
            ),
            border: InputBorder.none,
            hintText: "Enter $mode",
            hintStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        RaisedButton(
          onPressed: setPrefs,
          child: Text("Enter"),
          color: Colors.greenAccent,
        )
      ],
    );
  }
}
