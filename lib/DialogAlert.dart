import 'package:flutter/material.dart';

class DialogAlert extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String message;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function onPostivePressed;
  final Function onNegativePressed;
  final double circularBorderRadius;

  DialogAlert({
    required this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    required this.positiveBtnText,
    required this.negativeBtnText,
    required this.onPostivePressed,
    required this.onNegativePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: message != null ? Text(message) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        if (negativeBtnText != null)
          FlatButton(
            child: Text(negativeBtnText),
            textColor: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.of(context).pop();
              onNegativePressed();
            },
          )
        else
          FlatButton(
            child: Text('Cancel'),
            textColor: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.of(context).pop();
              onNegativePressed();
            },
          ),
        if (positiveBtnText != null)
          FlatButton(
            child: Text(positiveBtnText),
            textColor: Theme.of(context).accentColor,
            onPressed: () {
              onPostivePressed();
            },
          )
        else
          FlatButton(
            child: Text('Ok'),
            textColor: Theme.of(context).accentColor,
            onPressed: () {
              onPostivePressed();
            },
          ),
      ],
    );
  }
}
