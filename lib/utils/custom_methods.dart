// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

Future<String?> datePicker(context,
    {DateTime? initalDate, DateTime? lastDate, DateTime? firstDate}) async {
  late String? formattedDate;
  DateTime dd = DateTime.now();
  var yearNow = DateTime.now().year;
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initalDate ??
        DateTime(
          2000,
          dd.month,
          dd.day,
        ),
    firstDate: DateTime(
      2000,
      dd.month,
      dd.day,
    ),
    lastDate: lastDate ??
        ((initalDate != null)
            ? DateTime(yearNow + 10)
            : DateTime(
                yearNow - 15,
                dd.month,
                dd.day,
              )),
    errorFormatText: 'Enter valid date',
  );
  if (pickedDate != null) {
    formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    return formattedDate;
  } else {
    return null;
  }
}

String getErrorMessage(dynamic error) {
  if (error is SocketException) {
    return "Connection unavailable, please check your network.";
  } else if (error is Exception) {
    return error.toString().substring(11);
  } else {
    return "An unknown error occurred.";
  }
}

String getFileName(String filePath) {
  List<String> pathParts = filePath.split('/');
  String fileName = pathParts.last;
  return fileName;
}

String generateCaseId() {
  String prefix = "CA";
  String numericalPart = Random().nextInt(10000).toString().padLeft(4, '0');
  String caseId = '$prefix$numericalPart';
  return caseId;
}

String constructFCMPayload(String? token) {
  int messageCount = 0;
  messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$messageCount) was created via FCM!',
    },
  });
}

Future<void> sendPushMessage(token) async {
  if (token == null) {
    print('Unable to send FCM message, no token exists.');
    return;
  }

  try {
    await http.post(
      Uri.parse('https://api.rnfirebase.io/messaging/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: constructFCMPayload(token),
    );
    print('FCM request for device sent!');
  } catch (e) {
    print(e);
  }
}
