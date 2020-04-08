# Conversation
  
Conversation Widget For Flutter.  

## Demo
![enter image description here](https://media.giphy.com/media/cLkGCzyvhzBDQJyA0G/giphy.gif)
  
## Getting Started  
  
Obtain participants and their messages from oldest to newest and pass it to `ConversationWidget`

```dart
final GlobalKey<ConversationWidgetState> _key = GlobalKey<ConversationWidgetState>();
/// ...
ConversationWidget(  
  key: _key,  
  messages: _messages,  
  participants: _participants,
  sendMessageCallback: (body) async {
    await Future.delayed(Duration(seconds: 3));
    return true;
  },
),
```