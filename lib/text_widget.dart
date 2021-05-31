import 'package:chat_application/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextWidget extends StatelessWidget {
  final Message message;
  TextWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment:
            message.isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: message.isSent
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Chip(
              backgroundColor:
                  message.isSent ? Colors.blue.shade300 : Colors.white,
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message.message),
              ),
            ),
            Text(DateFormat('EEE, h:mm').format(message.timeLine)),
          ],
        ),
      ),
    );
  }
}
