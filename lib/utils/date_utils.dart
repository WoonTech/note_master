import 'package:flutter/material.dart';

extension StringClean on String {
  String cleanString() {
    var cleanedString = replaceAll(RegExp(r'^[\s\n]+'), '');
    cleanedString = cleanedString.replaceAll(RegExp(r'\n\s*'), ' ');
    return cleanedString;
  }
}

extension StringExtension on String {
  String toValidDuration(Duration duration) {
    String reminder = '';
    if (duration.inDays > 0) {
      reminder = '${duration.inDays} days';
    } else if (duration.inHours > 0) {
      reminder = '${duration.inHours} hours';
    } else if (duration.inMinutes > 0) {
      reminder = '${duration.inMinutes} minutes';
    } else if (duration.inSeconds > 0) {
      reminder = '${duration.inSeconds} seconds';
    }
    return reminder;
  }
}
