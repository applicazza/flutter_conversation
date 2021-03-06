import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageInfoWidget extends StatefulWidget {
  final Message message;

  MessageInfoWidget({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  _MessageInfoWidgetState createState() => _MessageInfoWidgetState();
}

class _MessageInfoWidgetState extends State<MessageInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final dateFormatter = DateFormat.yMd(locale).add_Hms();

    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: dateFormatter.format(widget.message.sentAt),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
            ),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  _getIcon(),
                  color: Theme.of(context).primaryColor,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (widget.message.state) {
      case MessageState.PENDING:
        return Icons.access_time;
      case MessageState.DELIVERED:
        return Icons.done;
      case MessageState.VIEWED:
        return Icons.done_all;
    }
    return Icons.error_outline;
  }
}
