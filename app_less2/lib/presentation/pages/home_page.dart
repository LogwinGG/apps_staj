// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:app_less2/application/main_bloc.dart';
import 'package:app_less2/application/main_bloc_event.dart';
import 'package:app_less2/application/main_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  MainBloc bloc = MainBloc();


  @override
  void initState() {
    super.initState();
    bloc.add(GetUserData());
  }

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
                bloc.add(SignOut());
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

              BlocBuilder(
                bloc: bloc,
                builder: (BuildContext context, MainBlocState state){
                  if(state is Loading) return Center(child: CircularProgressIndicator());
                  if(state is IsError) return Text('Произошла ошибка, проверьте соединение с интернетом', style: TextStyle(color: Colors.redAccent),);
                  if(state is UserDataState) {
                    Map<String, dynamic> data = state.userData;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('email: ${data['login']}', style: TextStyle(fontWeight: FontWeight.w600),),
                        SizedBox(height: 5),
                        Text('password: ${data['password']}',style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    );
                  }
                  return SizedBox();
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
