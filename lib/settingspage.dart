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
  String userName; // Variable that holds username

  // Global Functions

  // Function that sets the values updated for the shared preferences
  Future setValuesToSharedPrefferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Part 1 - USERNAME
    // Getting the username from the text controller
    String userName = userNameController.text;
    // Setting the username
    prefs.setString("User Name", userName);
    print("Username: $userName Set");

    // Setting the toast
    Fluttertoast.showToast(msg: "New Settings Saved");
  }

  // Function that gets the username for the hint
  Future<String> getUserNameForHint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("User Name").toString();
  }

  @override
  Widget build(BuildContext context) {
    // Getting the username for hint
    getUserNameForHint().then((value) {
      setState(() {
        userName = value;
        print(userName);
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
                  color: Colors.green,
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
        ],
      ),
    );
  }
}
