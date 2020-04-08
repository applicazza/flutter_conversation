import 'package:meta/meta.dart';

class Message {
  final int id;

  final DateTime sentAt;

  final String body;

  final int from;

  bool isDelivered;

  bool isViewed;

  Message({
    @required this.id,
    @required this.sentAt,
    @required this.body,
    @required this.from,
    this.isDelivered = false,
    this.isViewed = false,
  });
}
