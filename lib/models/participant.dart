import 'package:meta/meta.dart';

class Participant {
  final int id;

  final String name;

  final String avatar;

  final bool isMyself;

  Participant({
    @required this.id,
    @required this.name,
    this.avatar,
    this.isMyself = false,
  });
}
