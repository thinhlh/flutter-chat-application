import 'dart:async';

import 'package:chat_application/message.dart';
import 'package:chat_application/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat_screen.dart';
  final String opponentId;
  final String opponentName;

  String chatId;
  TextEditingController _controller = TextEditingController();

  FirebaseFirestore mFirestore = FirebaseFirestore.instance;
  FirebaseAuth mAuth = FirebaseAuth.instance;

  ChatScreen({@required this.opponentId, @required this.opponentName}) {
    //
  }

  void _onSend() {
    mFirestore
        .collection('groupChats')
        .doc(mAuth.currentUser.uid + '-$opponentId')
        .collection('messages')
        .doc()
        .set({'message': _controller.text, 'timeline': DateTime.now()}).then(
            (value) => _controller.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          this.opponentName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
            builder: (_,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot1) =>
                StreamBuilder(
              builder: (_,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot2) {
                if (!snapshot1.hasData || !snapshot2.hasData) {
                  return Container();
                }

                if (snapshot1.data.size + snapshot2.data.size <= 0) {
                  return Center(
                    child: Text(
                      'No Message Yet',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }

                List<Message> messages = [];
                snapshot1.data.docs.forEach((element) {
                  Map<String, dynamic> json = element.data();
                  json['isSent'] = false;
                  json['id'] = element.id;
                  messages.add(Message.fromJson(json));
                });
                snapshot2.data.docs.forEach((element) {
                  Map<String, dynamic> json = element.data();
                  json['isSent'] = true;
                  json['id'] = element.id;
                  messages.add(Message.fromJson(json));
                });

                messages
                    .sort((a, b) => a.timeLine.isBefore(b.timeLine) ? -1 : 1);

                return ListView.builder(
                  itemBuilder: (_, index) => TextWidget(messages[index]),
                  itemCount: messages.length,
                );
              },
              stream: mFirestore
                  .collection('groupChats')
                  .doc(mAuth.currentUser.uid + '-$opponentId')
                  .collection('messages')
                  .snapshots(),
            ),
            stream: mFirestore
                .collection('groupChats')
                .doc('$opponentId-' + mAuth.currentUser.uid)
                .collection('messages')
                .snapshots(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: null,
                  controller: _controller,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Write message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: _onSend,
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
