import 'package:flutter/material.dart';

class TimeLineData{
  final String title;
  final String content;
  final Color iconColor;

  const TimeLineData({this.title, this.content, this.iconColor});
}

const List<TimeLineData> timeLines = [
  TimeLineData(
    content: 'test timeline list',
    iconColor: Colors.red
  ),
  TimeLineData(
    content: 'test timeline list',
    iconColor: Colors.red
  ),
  TimeLineData(
    content: "test timeline list",
    iconColor: Colors.red
  ),
  TimeLineData(
    content: "test timeline list",
    iconColor: Colors.red
  ),
];

List <TimeLineData> qrList = [
  
];