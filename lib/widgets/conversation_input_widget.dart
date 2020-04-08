import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';

class ConversationInputWidget extends StatefulWidget {
  final SendMessageCallback sendMessageCallback;

  ConversationInputWidget({
    Key key,
    @required this.sendMessageCallback,
  }) : super(key: key);

  @override
  _ConversationInputWidgetState createState() => _ConversationInputWidgetState();
}

class _ConversationInputWidgetState extends State<ConversationInputWidget> {
  bool _isSending = false;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  hasFloatingPlaceholder: false,
                  labelText: 'Enter your message',
                  suffixIcon: IconButton(
                    onPressed: _isSending
                        ? null
                        : () async {
                            setState(() {
                              _isSending = true;
                            });

                            if (await widget.sendMessageCallback(_textEditingController.text)) {
                              _textEditingController.clear();
                            }

                            setState(() {
                              _isSending = false;
                            });
                          },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
