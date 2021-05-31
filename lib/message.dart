import 'package:flutter/foundation.dart';

class Message {
  final String id;
  final String message;
  final DateTime timeLine;
  final bool isSent;
  Message({
    @required this.id,
    @required this.message,
    @required this.timeLine,
    @required this.isSent,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
        message: json['message'],
        timeLine: json['timeline'].toDate(),
        isSent: json['isSent']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result;
    result['message'] = this.message;
    result['timeline'] = this.timeLine;
    return result;
  }
}
