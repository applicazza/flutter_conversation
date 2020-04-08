import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class SystemMessageWidget extends StatefulWidget {
  final String body;

  SystemMessageWidget({
    Key key,
    this.body,
  }) : super(key: key);

  @override
  _SystemMessageWidgetState createState() => _SystemMessageWidgetState();
}

class _SystemMessageWidgetState extends State<SystemMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: Color.fromRGBO(212, 234, 244, 1.0),
      child: Text(
        widget.body,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11.0),
      ),
    );
  }
}
