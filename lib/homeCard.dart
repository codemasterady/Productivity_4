import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  String type;
  Color cardColor;
  String status;
  Function cardFunction;
  Function longPressCardFunction;
  HomeCard(this.type, this.cardColor, this.status, this.cardFunction,
      this.longPressCardFunction);
  @override
  Widget build(BuildContext cntxt) {
    return GestureDetector(
      onLongPress: this.longPressCardFunction,
      onTap: cardFunction,
      child: Container(
        width: 185,
        height: 185,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [cardColor, Colors.white70]),
          border: Border.all(width: 2, color: cardColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
