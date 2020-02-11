import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingIndicator extends StatelessWidget {
  final double androidStrokeWidth;
  final Color androidStrokeColor;
  final double iosRadius;

  LoadingIndicator({
    this.androidStrokeWidth = 3.0,
    this.androidStrokeColor = Colors.grey,
    this.iosRadius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? CircularProgressIndicator(
            strokeWidth: androidStrokeWidth,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(androidStrokeColor),
          )
        : CupertinoActivityIndicator(
            radius: iosRadius,
          );
  }
}
