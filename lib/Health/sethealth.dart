import 'package:flutter/material.dart';

class SetHealth extends StatefulWidget {
  @override
  _SetHealthState createState() => _SetHealthState();
}

class _SetHealthState extends State<SetHealth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.green,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("Register Your Health Progress"),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
