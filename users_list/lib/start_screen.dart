// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:users_list/detail_screen.dart';
import 'package:users_list/user_model.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  List<User> users = [];

  int _selectedIndex = -1;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemCount: users.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                itemBuilder: (context, index) {
                  if (users != []) {
                    User user = users[index];
                    return ListTile(
                      title: Text(user.username),
                      tileColor: Colors.greenAccent.withOpacity(0.1),
                      selected: index == _selectedIndex,
                      selectedTileColor: Colors.greenAccent.withOpacity(0.4),
                      selectedColor: Colors.black,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    title: Text(user.username),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Фамилия: ${user.surname}'),
                                          Text('Имя: ${user.name}'),
                                          Text('Номер: ${user.number}'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      MaterialButton(
                                          child: Text('Редактировать'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            var result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                        DetailScreen.fromData(user)));
                                            if (result != null) {
                                              setState(() {
                                                users[index] = result;
                                              });
                                            }
                                          }
                                          ),
                                    ]));
                      }
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        MaterialButton(
          child: Text('Удалить'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Colors.greenAccent,
          onPressed: () {
            if (_selectedIndex != -1) {
              showDialog(context: context, builder: (context) =>
                  AlertDialog(
                    title: Text('Удалить пользователя "${users[_selectedIndex]
                        .username}" ?'),
                    actions: [
                      MaterialButton(
                          child: Text('Да'),
                          onPressed: () {
                            setState(() {
                              users.removeAt(_selectedIndex);
                              _selectedIndex = -1;
                            });
                            Navigator.pop(context);
                          }),
                    ],
                  )
              );
            } else {
              showDialog(context: context, builder: (context) =>
                  AlertDialog(
                    title: Text('Выберите пользователя'),
                  ));
            }


          },
        ),
        SizedBox(width: 15,),
        MaterialButton(
          child: Text('Добавить пользователя'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Colors.greenAccent,
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailScreen()));

            if (result != null) {
              setState(() {
                users.add(result);
              });
            }
          },
        ),
      ]),
    );
  }
}
