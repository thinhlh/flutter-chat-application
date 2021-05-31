import 'package:chat_application/auth_screen.dart';
import 'package:chat_application/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  final FirebaseAuth mAuth = FirebaseAuth.instance;
  final FirebaseFirestore mFireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ElevatedButton(
          child: Text('Sign Out'),
          onPressed: () => mAuth.signOut().then((value) =>
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName)),
        ),
      ),
      appBar: AppBar(
        title: Text(mAuth.currentUser.displayName),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          builder: (_,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot) =>
              snapshot.hasData
                  ? ListView.builder(
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                    opponentId: snapshot.data.docs[index].id,
                                    opponentName: snapshot.data.docs[index]
                                        .data()['name']),
                              ),
                            ),
                            title:
                                Text(snapshot.data.docs[index].data()['name']),
                            leading: Icon(Icons.face),
                            trailing: Icon(Icons.more_horiz),
                          ),
                        ),
                      ),
                      itemCount: snapshot.data.docs.length,
                    )
                  : Container(),
          stream: mFireStore
              .collection('users')
              .where(FieldPath.documentId, isNotEqualTo: mAuth.currentUser.uid)
              .snapshots(),
        ),
      ),
    );
  }
}
