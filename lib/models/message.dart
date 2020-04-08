import 'package:meta/meta.dart';

class Message {
  final int id;

  final DateTime sentAt;

  final String body;

  final int from;

  MessageState state;

  Message({
    @required this.id,
    @required this.sentAt,
    @required this.body,
    @required this.from,
    @required this.state,
  });
}

enum MessageState {
  PENDING,
  DELIVERED,
  VIEWED,
}
