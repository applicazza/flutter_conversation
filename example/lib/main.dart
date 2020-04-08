import 'dart:math';

import 'package:conversation/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lipsum/lipsum.dart';

void main() => runApp(AppRoot());

class AppRoot extends StatefulWidget {
  AppRoot({Key key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final GlobalKey<ConversationWidgetState> _key = GlobalKey<ConversationWidgetState>();

  final List<Message> _messages = List<Message>();

  final List<Participant> _participants = List<Participant>();

  @override
  void initState() {
    super.initState();

    _messages.addAll(_generateMessages(0));
    _participants.addAll(_generateParticipants());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                _key.currentState.jumpToLast();
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                _key.currentState.jumpToFirst();
              },
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                final messages = _generateMessages(_messages.length);
                setState(() {
                  _messages.addAll(messages);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                setState(() {
                  final lastMessage = _messages.last;
                  lastMessage.isDelivered = true;
                  lastMessage.isViewed = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.done_all),
              onPressed: () {
                setState(() {
                  final lastMessage = _messages.last;
                  lastMessage.isDelivered = true;
                  lastMessage.isViewed = true;
                });
              },
            ),
          ],
          title: Text('Conversation'),
        ),
        body: ConversationWidget(
          key: _key,
          messages: _messages,
          participants: _participants,
          sendMessageCallback: (body) async {
            await Future.delayed(Duration(seconds: 3));
            return true;
          },
        ),
      ),
      locale: Locale('en'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('he'), // Hebrew
      ],
    );
  }

  Iterable<Message> _generateMessages(
    int from, {
    int length = 100000,
  }) {
    final random = Random();
    final now = DateTime.now();
    final initialSentAt = now.subtract(Duration(days: 300));

    return List.generate(length, (index) {
      final isDelivered = random.nextBool();
      return Message(
        id: from + index + 1,
        body: random.nextBool()
            ? createSentence()
            : 'הראשי לימודים ב שתי, ב ובמתן הבהרה המקובל מלא. זאת גם מרצועת הספרות, מה היא כלליים קלאסיים. אחר דת באגים ולחבר. כלל את ריקוד קולנוע העברית, נפלו פולנית קצרמרים דת לוח, ויש או אחרים בקרבת המדינה.',
        from: random.nextInt(3) + 1,
        sentAt: initialSentAt.add(Duration(hours: (from + index))),
        isDelivered: isDelivered,
        isViewed: isDelivered && random.nextBool(),
      );
    });
  }

  Iterable<Participant> _generateParticipants() {
    return [
      Participant(
        id: 1,
        name: 'רוני אלמוני',
        isMyself: true,
      ),
      Participant(
        id: 2,
        name: 'ישראל ישראלי',
      ),
      Participant(
        id: 3,
        name: 'Third Participant',
      ),
    ];
  }
}
