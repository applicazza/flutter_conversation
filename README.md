# Conversation
  
Conversation Widget For Flutter.  

## Demo
![enter image description here](https://media.giphy.com/media/cLkGCzyvhzBDQJyA0G/giphy.gif)
  
## Getting Started  

Create ```GlobalKey``` for ```ConversationWidgetState``` in case you need to manipulate it's state

```dart
final GlobalKey<ConversationWidgetState> _key = GlobalKey<ConversationWidgetState>();
```

Obtain participants and their messages from oldest to newest

```dart
final _messages = List<Message>()
  ..addAll([
    Message(
      id: 1,
      sentAt: DateTime.now(),
      body: 'Test #1',
      from: 1,
    ),
    Message(
      id: 2,
      sentAt: DateTime.now(),
      body: 'Test #2',
      from: 2,
    ),
    Message(
      id: 3,
      sentAt: DateTime.now(),
      body: 'Test #3',
      from: 3,
    ),
  ]);

final _participants = [
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
```

Finally, pass mentioned data along with ```messageViewedCallback``` and ```sendMessageCallback``` to ```ConversationWidget```

```dart
/// ...
ConversationWidget(  
  key: _key,  
  messages: _messages,
  messageViewedCallback: (message, index) async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      message.state = MessageState.VIEWED;
    });
  },
  participants: _participants,
  sendMessageCallback: (body) async {
    await Future.delayed(Duration(seconds: 3));
    return true;
  },
),
```