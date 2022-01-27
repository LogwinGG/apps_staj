// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:app_less2/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  AuthService _authService = AuthService();

  CollectionReference userDataRef = FirebaseFirestore.instance.collection('${FirebaseAuth.instance.currentUser?.uid}');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter login demo',
        ),
        centerTitle: true,
        actions: [
          MaterialButton(
              child: Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onPressed: () {
                _authService.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 200,
                  child: Text('Welcome', style: TextStyle(fontSize: 34.0)),
                ),
              ),

              FutureBuilder(
                future: userDataRef.get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                  if (snapshot.hasError) Text(snapshot.error.toString());
                  if (snapshot.connectionState == ConnectionState.waiting) CircularProgressIndicator();

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data!.docs[0].data();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('email: ${data['login']}', style: TextStyle(fontWeight: FontWeight.w600),),
                        SizedBox(height: 5),
                        Text('password: ${data['password']}',style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    );
                  }
                  return CircularProgressIndicator();;
                }),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
        },
      ),
    );
  }
}
