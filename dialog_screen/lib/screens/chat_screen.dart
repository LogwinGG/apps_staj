// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, unused_element, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerName;

  ChatScreen({Key? key, required this.peerId, required this.peerName})
      : super(key: key);

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(peerId: peerId, peerName: peerName);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({Key? key, required this.peerId, required this.peerName});

  String peerId;
  String peerName;
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];

  String groupChatId = "";

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
  }

  void onSendMessage(String text) {
    if (text.trim().isNotEmpty) {
      setState(() { textEditingController.clear();});

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': currentUserId,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': text
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[800],
          toolbarHeight: 60,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.cyan,
                radius: 22,
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 10,
              ),
              Text(peerName),
            ],
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        ),
        body: Column(
          children: <Widget>[
            /// list messages
            Flexible(child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue.shade800)));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,

                    itemBuilder: (context, index) {
                      Map<String, dynamic>? message = snapshot.data?.docs[index].data();
                      bool isMe = message!['idFrom'] == currentUserId;

                      return Row(
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start ,
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              margin: EdgeInsets.only(bottom: 10.0, ),
                              constraints: BoxConstraints(maxWidth: 280),
                              decoration: BoxDecoration(
                                  color: isMe ? Colors.lightGreenAccent.shade100.withOpacity(0.6) : Colors.white,
                                  borderRadius: isMe
                                      ? BorderRadius.circular(7.0).subtract(BorderRadius.only(bottomRight: Radius.circular(7)))
                                      : BorderRadius.circular(7.0).subtract(BorderRadius.only(bottomLeft:  Radius.circular(7)))
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end ,
                                children: [
                                  Text('${message['text']}', textAlign: isMe ? TextAlign.end : TextAlign.start,),
                                  Text( DateFormat('kk:mm')
                                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(message['timestamp']))),
                                        textAlign: TextAlign.right,

                                        style: TextStyle(color: Colors.green, fontSize: 9, fontStyle: FontStyle.italic ,),
                                      ),
                                ],
                              )
                            ),


                        ],
                      );
                    },
                  );
                }
              },
            )),
            ///input message
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Colors.black.withOpacity(0.1), width: 1)),
                  color: Colors.white),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        child: IconButton(
                          icon: Icon(Icons.tag_faces),
                          onPressed: () {},
                        ),
                      ),
                      color: Colors.white,
                    ),
                    Flexible(
                      child: TextField(
                        style: TextStyle(fontSize: 15),
                        controller: textEditingController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Сообщение',
                          hintStyle: TextStyle(
                            color: Colors.grey[600]?.withOpacity(0.5),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    textEditingController.text.trim().isNotEmpty
                        ? Material(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              child: IconButton(
                                icon: Icon(Icons.send),
                                color: Colors.lightBlue[800],
                                onPressed: () =>
                                    onSendMessage(textEditingController.text),
                              ),
                            ),
                            color: Colors.white,
                          )
                        : Row(
                            children: [
                              Material(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 1),
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file_outlined),
                                    onPressed: () {},
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              Material(
                                child: IconButton(
                                  icon: Icon(Icons.mic_none),
                                  onPressed: () {},
                                ),
                                color: Colors.white,
                              )
                            ],
                          ),
                  ]),
            )
          ],
        ));
  }
}
