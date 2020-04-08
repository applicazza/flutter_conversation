import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef SendMessageCallback = Future<bool> Function(String body);
typedef MessageViewedCallback = Future<void> Function(Message message, int index);

class ConversationWidget extends StatefulWidget {
  final List<Message> messages;

  final List<Participant> participants;

  final BubbleStyle myBubbleStyle;

  final BubbleStyle otherBubbleStyle;

  final SendMessageCallback sendMessageCallback;

  final MessageViewedCallback messageViewedCallback;

  ConversationWidget({
    Key key,
    @required this.messages,
    @required this.participants,
    @required this.sendMessageCallback,
    @required this.messageViewedCallback,
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
        assert(sendMessageCallback != null),
        assert(sendMessageCallback != null),
        assert(messageViewedCallback != null),
        super(key: key);

  @override
  ConversationWidgetState createState() => ConversationWidgetState();
}

class ConversationWidgetState extends State<ConversationWidget> {
  final Set<int> _notifiedMessageIds = Set<int>();

  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final Map<int, Participant> _participantsMap = Map<int, Participant>();

  bool _showScrollDown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Scrollbar(
                child: ScrollablePositionedList.builder(
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
              ),
              _showScrollDown
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
          ),
        ),
        ConversationInputWidget(
          sendMessageCallback: widget.sendMessageCallback,
        ),
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

    final maxPositionIndex = max(firstPositionIndex, lastPositionIndex);
    final minPositionIndex = min(firstPositionIndex, lastPositionIndex);
    final showScrollDown = maxPositionIndex < widget.messages.length - 1;

    if (_showScrollDown != showScrollDown) {
      setState(() {
        _showScrollDown = showScrollDown;
      });
    }

    for (var i = minPositionIndex; i <= maxPositionIndex; i++) {
      final message = widget.messages[i];
      if (widget.messages[i].state != MessageState.VIEWED && !_notifiedMessageIds.contains(message.id)) {
        widget.messageViewedCallback(message, i);
        _notifiedMessageIds.add(message.id);
      }
    }
  }
}
