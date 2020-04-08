import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConversationWidget extends StatefulWidget {
  final List<Message> messages;

  final List<Participant> participants;

  final BubbleStyle myBubbleStyle;

  final BubbleStyle otherBubbleStyle;

  ConversationWidget({
    Key key,
    @required this.messages,
    @required this.participants,
    this.myBubbleStyle = const BubbleStyle(
      nip: BubbleNip.rightBottom,
      color: Color.fromARGB(255, 225, 255, 199),
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
    ),
    this.otherBubbleStyle = const BubbleStyle(
      nip: BubbleNip.leftBottom,
      color: Colors.white,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
    ),
  })  : assert(myBubbleStyle != null),
        assert(otherBubbleStyle != null),
        super(key: key);

  @override
  ConversationWidgetState createState() => ConversationWidgetState();
}

class ConversationWidgetState extends State<ConversationWidget> {
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final Map<int, Participant> _participantsMap = Map<int, Participant>();

  bool _showScrollDown = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ScrollablePositionedList.builder(
          itemBuilder: (context, index) {
            final locale = Localizations.localeOf(context).toString();
            final dateFormatter = DateFormat.yMd(locale);
            final messages = widget.messages;
            final message = messages[index];
            final nextMessage = index + 1 != messages.length ? messages[index + 1] : null;
            return Column(
              children: <Widget>[
                MessageWidget(
                  message: message,
                  myBubbleStyle: widget.myBubbleStyle,
                  otherBubbleStyle: widget.otherBubbleStyle,
                  sender: _participantsMap[message.from],
                ),
                nextMessage != null && !_isSameDayMessage(message, nextMessage)
                    ? SystemMessageWidget(
                        body: dateFormatter.format(nextMessage.sentAt.toLocal()),
                      )
                    : Container(),
              ],
            );
          },
          itemCount: widget.messages.length,
          itemPositionsListener: _itemPositionsListener,
          itemScrollController: _itemScrollController,
        ),
        _showScrollDown
            ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RawMaterialButton(
                    child: Icon(
                      Icons.arrow_downward,
                      color: Theme.of(context).primaryIconTheme.color,
                      size: 24.0,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 36.0,
                      minHeight: 36.0,
                    ),
                    elevation: 2.0,
                    fillColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      jumpToLast();
                    },
                    shape: CircleBorder(),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    widget.participants.forEach((p) => _participantsMap[p.id] = p);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumpToLast();
    });

    _itemPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onItemPositionsChanged);

    super.dispose();
  }

  void jumpToFirst() {
    _itemScrollController.jumpTo(index: 0);
  }

  void jumpToLast() {
    _itemScrollController.jumpTo(index: widget.messages.length - 1);
  }

  bool _isSameDayMessage(Message first, Message second) {
    return first.sentAt.year == second.sentAt.year &&
        first.sentAt.month == second.sentAt.month &&
        first.sentAt.day == second.sentAt.day;
  }

  void _onItemPositionsChanged() {
    final firstPositionIndex = _itemPositionsListener.itemPositions.value.first.index;
    final lastPositionIndex = _itemPositionsListener.itemPositions.value.last.index;
    final positionIndex = max(firstPositionIndex, lastPositionIndex);
    final showScrollDown = positionIndex < widget.messages.length - 1;
    if (_showScrollDown != showScrollDown) {
      setState(() {
        _showScrollDown = showScrollDown;
      });
    }
  }
}
