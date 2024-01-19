import 'package:flutter/material.dart';

class AlertsClass {
  ResponseMessageHandler(BuildContext context, ResponseMessage) {
    // var apitype = 3;
    Widget cancelButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        //Navigator.pop(context, false);
        Future.delayed(Duration.zero, () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          // Navigator.of(context, rootNavigator: true).pop('dialog');
        });
      },
    );

    // set up the AlertDialog
    String Error = "An error occured please try again later";

    ResponseMessage == null ? ResponseMessage = Error : ResponseMessage;
    AlertDialog alert = AlertDialog(
      title: const Center(child: const Text("Alert")),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ResponseMessage,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ]),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
