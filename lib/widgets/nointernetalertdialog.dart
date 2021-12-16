import 'package:flutter/material.dart';

class NoInternetAlertDialog extends StatelessWidget {
  const NoInternetAlertDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "No Internet Connection",
      ),
      content: Text(
        "Check your network settings and try again.",
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
