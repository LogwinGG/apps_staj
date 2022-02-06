// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_screen/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 60, backgroundColor: Colors.lightBlue[800]),
      drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('${user?.displayName}'),
                accountEmail: Text('${user?.email}'),
                decoration:  BoxDecoration(
                  color: Colors.lightBlue[800],
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.cyan,
                  child: Icon(Icons.person),
                  radius: 10,
                ),
              )
            ],
          )),
      /// list users
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var userChat = snapshot.data?.docs[index].data();

                if (userChat?['id'] == user?.uid)
                  return SizedBox.shrink();
                else {
                  return ListTile(
                    title: Text('${userChat?['name']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            peerId: userChat?['id'],
                            peerName: userChat?['name'],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
