import 'package:bubble/bubble.dart';
import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final Message message;

  final Participant sender;

  final BubbleStyle myBubbleStyle;

  final BubbleStyle otherBubbleStyle;

  MessageWidget({
    Key key,
    @required this.message,
    @required this.sender,
    @required this.myBubbleStyle,
    @required this.otherBubbleStyle,
  })  : assert(myBubbleStyle != null),
        assert(otherBubbleStyle != null),
        super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Bubble(
      child: Column(
        children: <Widget>[
          MessageSenderWidget(sender: widget.sender),
          MessageBodyWidget(message: widget.message),
          MessageInfoWidget(message: widget.message),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: BubbleEdges.all(8.0),
      padding: BubbleEdges.all(8.0),
      style: _getBubbleStyle(),
    );
  }

  BubbleStyle _getBubbleStyle() {
    return widget.sender.isMyself ? widget.myBubbleStyle : widget.otherBubbleStyle;
  }
}
