import 'package:flutter/material.dart';

showSimpleDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'OK',
            style: Theme.of(context).primaryTextTheme.button,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
