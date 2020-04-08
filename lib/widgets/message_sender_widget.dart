import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';

class MessageSenderWidget extends StatefulWidget {
  final Participant sender;

  MessageSenderWidget({
    Key key,
    this.sender,
  }) : super(key: key);

  @override
  _MessageSenderWidgetState createState() => _MessageSenderWidgetState();
}

class _MessageSenderWidgetState extends State<MessageSenderWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _getAlignment(),
      child: Text(
        widget.sender.name,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  AlignmentGeometry _getAlignment() {
    return widget.sender.isMyself ? Alignment.topRight : Alignment.topLeft;
  }
}
