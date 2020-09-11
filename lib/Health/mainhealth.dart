import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

import './sethealth.dart';
import './healthentertextalertdialog.dart';

class MainHealth extends StatefulWidget {
  @override
  _MainHealthState createState() => _MainHealthState();
}

class _MainHealthState extends State<MainHealth> {
  // Global variables
  Icon stepsVariablesIcon = Icon(
    Icons.directions_run,
    color: Colors.white,
  );
  Icon caloriesVariableIcon = Icon(
    Icons.local_dining,
    color: Colors.white,
  );
  Icon sleepVariableIcon = Icon(
    Icons.brightness_3,
    color: Colors.white,
  );
  Icon calBurntVariableIcon = Icon(
    Icons.flare,
    color: Colors.white,
  );
  int stepsGoal;
  int caloriesGoal;
  int sleepGoal;
  int stepsTaken;
  int caloriesTaken;
  int sleepTaken;
  int caloriesBurnt;
  bool isCalorieBalancePositive;
  bool stepsGoalReached = false;
  bool calorieIntakeGoalReached = false;
  bool sleepIntakeGoalReached = false;
  double healthProgress = 0;
  double calorieBalance;
  double ultimateGoalRatio;
  Color healthProgressIndicatorColor;
  Color calorieBalancePercentIndicatorColor;
  List<bool> listOfCompleted = [];
  Text caloricBalanceStatus = Text(
    "Your Caloric Balance: Positive",
    style: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );

  // Global Function

  // Getting steps goal
  Future<int> getSharedPreferencesStepsGoal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("Steps Target").toInt();
  }

  // Getting calories goal
  Future<int> getSharedPreferencesCaloriesGoal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("Caloric Target").toInt();
  }

  // Getting sleep goal
  Future<int> getSharedPreferencesSleepGoal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("Sleep Target").toInt();
  }

  // Getting the steps taken
  Future<int> getSharedPreferencesStepsTaken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("Steps Taken Today");
  }

  // Getting the calories taken
  Future<int> getSharedPreferencesCaloriesTaken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("Calories Taken Today");
  }

  // Getting the sleep taken
  Future<int> getSharedPreferencesSleepTaken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("Sleep Taken Today");
  }

  // Getting the sleep taken
  Future<int> getSharedPreferencesCaloriesBurnt() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("Calories Burnt Today");
  }

  // Checking if calorie less or more
  double calorieBalanceComputer(int caloriesTaken, int caloriesBurnt) {
    int balance = caloriesBurnt - caloriesTaken;
    if (balance < 1) {
      return balance / (caloriesTaken);
    } else {
      return balance / caloriesBurnt;
    }
  }

  // Checking if calorie balance is + or -
  bool calorieBalanceReturningStatus(double balanceRatio) {
    if (balanceRatio < 0.0) {
      return false;
    } else {
      return true;
    }
  }

  // Computing how many ultimate tasks were completed
  double completedHealthGoals(List<bool> param) {
    int total = param.length;
    double completionRatio;
    int numberOfTrue = 0;
    int numberOfFalse = 0;
    for (bool item in param) {
      if (item == true) {
        numberOfTrue = numberOfTrue + 1;
      } else {
        numberOfFalse = numberOfFalse + 1;
      }
    }
    completionRatio = numberOfTrue / total;
    return completionRatio;
  }

  // Resetting progress if new day
  resetProgressIfNewDay() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastSaved = prefs.getString("Health Recorded Data Date");
    if (formattedDate != lastSaved) {
      prefs.setInt("Steps Taken Today", 0);
      prefs.setInt("Calories Taken Today", 0);
      prefs.setInt("Sleep Taken Today", 0);
      prefs.setInt("Calories Burnt Today", 0);
    }
  }

  // Function to set shared prefferences for main screen
  setSharedPrefsForMainScreen(double param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("Health Progress", param);
  }

  // Function to set the progress bar (Ultimate)
  double progressBarSetter(bool p1, bool p2, bool p3, bool p4) {
    List listOfBools = [];
    int numOfTrue = 0;
    double returningVal;

    listOfBools.add(p1);
    listOfBools.add(p2);
    listOfBools.add(p3);
    listOfBools.add(p4);

    for (bool item in listOfBools) {
      if (item == true) {
        numOfTrue = numOfTrue + 1;
      }
    }
    int listLen = listOfBools.length;
    returningVal = numOfTrue / listLen;
    return returningVal;
  }

  @override
  Widget build(BuildContext context) {
    // Resetting if new day
    resetProgressIfNewDay();
    // Getting the steps goal
    getSharedPreferencesStepsGoal().then((value) {
      setState(() {
        stepsGoal = value;
        if (stepsGoal == null) {
          stepsGoal = 1;
        }
      });
    });
    // Getting the calories goal
    getSharedPreferencesCaloriesGoal().then((value) {
      setState(() {
        caloriesGoal = value;
        if (caloriesGoal == null) {
          caloriesGoal = 1;
        }
      });
    });
    // Getting the sleep goal
    getSharedPreferencesSleepGoal().then((value) {
      setState(() {
        sleepGoal = value;
        if (sleepGoal == null) {
          sleepGoal = 1;
        }
      });
    });
    // Getting the steps taken
    getSharedPreferencesStepsTaken().then((value) {
      setState(() {
        stepsTaken = value;
        if (stepsTaken == null) {
          stepsTaken = 0;
        }
        if (stepsTaken > stepsGoal) {
          stepsTaken = stepsGoal;
        }
      });
    });
    // Getting the calories taken
    getSharedPreferencesCaloriesTaken().then((value) {
      setState(() {
        caloriesTaken = value;
        if (caloriesTaken == null) {
          caloriesTaken = 0;
        }
        if (caloriesTaken > caloriesGoal) {
          caloriesTaken = caloriesGoal;
        }
      });
    });
    // Getting the steps taken
    getSharedPreferencesSleepTaken().then((value) {
      setState(() {
        sleepTaken = value;
        if (sleepTaken == null) {
          sleepTaken = 0;
        }
        if (sleepTaken > sleepGoal) {
          sleepTaken = sleepGoal;
        }
      });
    });
    // Getting the calories burnt
    getSharedPreferencesCaloriesBurnt().then((value) {
      setState(() {
        caloriesBurnt = value;
        if (caloriesBurnt == null) {
          caloriesBurnt = 0;
        }
      });
    });

    // If Statement to change color
    if (healthProgress >= (0.4) && healthProgress < 0.75) {
      healthProgressIndicatorColor = Colors.yellow;
    } else if (healthProgress >= 0.75 && healthProgress < 1) {
      healthProgressIndicatorColor = Colors.green;
    } else if (healthProgress < 0.4) {
      healthProgressIndicatorColor = Colors.red;
    } else {
      healthProgressIndicatorColor = Colors.lightGreen;
    }

    // Computing the calorie balance
    calorieBalance = calorieBalanceComputer(caloriesTaken, caloriesBurnt);
    // Checking if positive or negative
    isCalorieBalancePositive = calorieBalanceReturningStatus(calorieBalance);
    calorieBalance = calorieBalance.abs();
    if (calorieBalance > 1) {
      calorieBalance = 1;
    }

    // Changing color of text and percent indicator
    if (isCalorieBalancePositive == false) {
      setState(() {
        // Changing the text color
        caloricBalanceStatus = Text(
          "Your Caloric Balance is Negative",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
        // Changing the indicator color
        calorieBalancePercentIndicatorColor = Colors.red;
      });
    } else {
      setState(() {
        // Changing the text color
        caloricBalanceStatus = Text(
          "Your Caloric Balance is Positive!!",
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
        // Changing the indicator color
        calorieBalancePercentIndicatorColor = Colors.green;
      });
    }

    // Applying total progress
    setState(() {
      ultimateGoalRatio = healthProgress;
    });

    // Setting the final health bar
    if (stepsTaken == stepsGoal) {
      stepsGoalReached = true;
    }
    if (stepsTaken > stepsGoal) {
      stepsGoalReached = true;
    }
    if (caloriesTaken == caloriesGoal) {
      calorieIntakeGoalReached = true;
    }
    if (sleepTaken == sleepGoal) {
      sleepIntakeGoalReached = true;
    }
    setState(() {
      ultimateGoalRatio = progressBarSetter(
          stepsGoalReached,
          calorieIntakeGoalReached,
          sleepIntakeGoalReached,
          isCalorieBalancePositive);
      // Setting the ultimate progress for screen
      // setSharedPrefsForMainScreen(ultimateGoalRatio);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_download),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SetHealth(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.green,
        title: Text("Health"),
        leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Text(
            "Your Progress: ",
            textAlign: TextAlign.center,
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
            animateFromLastPercent: true,
            percent: ultimateGoalRatio,
            progressColor: healthProgressIndicatorColor,
            animation: true,
            animationDuration: 1000,
          ),
          Text("SPACE"),
          Text("SPACE"),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  child: HealthEnterTextAlertDialog("Steps Taken"));
            },
            child: Row(
              children: [
                Text("SPACE"),
                CircularPercentIndicator(
                  radius: 70,
                  animation: true,
                  animationDuration: 1500,
                  center: stepsVariablesIcon,
                  progressColor: Colors.greenAccent,
                  percent: stepsTaken / stepsGoal,
                ),
                Text("SPACE"),
                Text(
                  "Steps Progress",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text("SPACE"),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  child: HealthEnterTextAlertDialog("Calories Taken"));
            },
            child: Row(
              children: [
                Text("SPACE"),
                CircularPercentIndicator(
                  radius: 70,
                  animation: true,
                  animationDuration: 1500,
                  center: caloriesVariableIcon,
                  progressColor: Colors.greenAccent,
                  percent: caloriesTaken / caloriesGoal,
                ),
                Text("SPACE"),
                Text(
                  "Calories Intake",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text("SPACE"),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  child: HealthEnterTextAlertDialog("Sleep Taken"));
            },
            child: Row(
              children: [
                Text("SPACE"),
                CircularPercentIndicator(
                  radius: 70,
                  animation: true,
                  animationDuration: 1500,
                  center: sleepVariableIcon,
                  progressColor: Colors.deepPurpleAccent,
                  percent: sleepTaken / sleepGoal,
                ),
                Text("SPACE"),
                Text(
                  "Overall Sleep",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text("SPACE"),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  child: HealthEnterTextAlertDialog("Calories Burnt"));
            },
            child: Row(
              children: [
                Text("SPACE"),
                CircularPercentIndicator(
                  radius: 70,
                  animation: true,
                  animationDuration: 1500,
                  center: calBurntVariableIcon,
                  progressColor: Colors.greenAccent,
                  percent: sleepTaken / sleepGoal,
                ),
                Text("SPACE"),
                // LinearPercentIndicator(
                //   width: 100.0,
                //   lineHeight: 8.0,
                //   percent: 0.5,
                //   progressColor: Colors.orange,
                // ),
                Text(
                  "Calories Burnt",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Text("SPACE"),
          Text("SPACE"),
          Text("SPACE"),
          Divider(color: Colors.white),
          Text("SPACE"),
          Row(
            children: [
              LinearPercentIndicator(
                width: 155,
                alignment: MainAxisAlignment.center,
                lineHeight: 10,
                leading: Text(
                  "Shread",
                  style: TextStyle(color: Colors.white),
                ),
                percent: calorieBalance,
                progressColor: Colors.greenAccent,
                linearStrokeCap: LinearStrokeCap.butt,
                animation: true,
                animationDuration: 1000,
              ),
              LinearPercentIndicator(
                width: 155,
                alignment: MainAxisAlignment.center,
                lineHeight: 10,
                trailing: Text(
                  "Gain",
                  style: TextStyle(color: Colors.white),
                ),
                percent: 1 - calorieBalance,
                progressColor: Colors.red,
                linearStrokeCap: LinearStrokeCap.butt,
                animation: true,
                animationDuration: 1000,
              ),
            ],
          ),
          Text("SPCAE"),
          caloricBalanceStatus,
        ],
      ),
    );
  }
}
