import 'package:flutter/material.dart';

Card getCardLayout(dynamic data){
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Time : '+data['Time']),
            Padding(
              padding: EdgeInsets.all(2),
            ),
            Text('ETD : '+data['ETD']),
            Padding(
              padding: EdgeInsets.all(2),
            ),
            Text('Name : '+data['Name']),
            Padding(
              padding: EdgeInsets.all(2),
            ),
            Text('Paid : '+data['Paid'].toString())
          ],
        ),
      ],
    ),
  );
}