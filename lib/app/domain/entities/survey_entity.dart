import 'package:flutter/foundation.dart';

class Survey {
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  Survey({
    @required this.id,
    @required this.question,
    @required this.dateTime,
    @required this.didAnswer,
  });
}
