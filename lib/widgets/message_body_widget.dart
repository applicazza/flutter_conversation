import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class MessageBodyWidget extends StatefulWidget {
  final Message message;

  MessageBodyWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  _MessageBodyWidgetState createState() => _MessageBodyWidgetState();
}

class _MessageBodyWidgetState extends State<MessageBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        widget.message.body,
        textDirection: isRTL(widget.message.body) ? TextDirection.rtl : TextDirection.ltr,
      ),
    );
  }

  bool isRTL(String text) {
    return Bidi.detectRtlDirectionality(text);
  }
}
