// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, empty_constructor_bodies

import 'package:flutter/material.dart';
import 'package:users_list/user_model.dart';

class DetailScreen extends StatefulWidget {
   User? user;

   DetailScreen( { Key? key } ) : super(key: key) ;

   DetailScreen.fromData(this.user, {Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameTEC = TextEditingController();
  final TextEditingController _surnameTEC = TextEditingController();
  final TextEditingController _nameTEC = TextEditingController();
  final TextEditingController _numberTEC = TextEditingController();

  @override
  void initState() {
    if(widget.user != null) {
      _usernameTEC.text = widget.user!.username;
      _surnameTEC.text = widget.user!.surname;
      _nameTEC.text = widget.user!.name;
      _numberTEC.text = widget.user!.number;
    }
    super.initState();
  }
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User user = User(username: _usernameTEC.text,surname: _surnameTEC.text, name: _nameTEC.text,number: _numberTEC.text);
      Navigator.pop(context, user);
      _formKey.currentState!.reset();
    }
  }

  bool validateNumber(String value) {
    String pattern =
        r'^(\+)?((\d{2,3}) ?\d|\d)(([ -]?\d)|( ?(\d{2,3}) ?)){5,12}\d$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameTEC,
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == '')return '?????????????????? ????????';
                          else return null;
                        },
                      ),
                      TextFormField(
                        controller: _surnameTEC,
                        decoration: InputDecoration(labelText: '??????????????'),
                        validator: (value) {
                          if (value == '') return '?????????????????? ????????';
                          else return null;
                        },
                      ),
                      TextFormField(
                        controller: _nameTEC,
                        decoration: InputDecoration(labelText: '??????'),
                        validator: (value) {
                          if (value == '')return '?????????????????? ????????';
                          else return null;
                        },
                      ),
                      TextFormField(
                        controller: _numberTEC,
                        decoration: InputDecoration(labelText: '??????????????'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == '') return '?????????????????? ????????';
                          if (!validateNumber(value!)) return '?????????? ???????????? ?????????????????? 11 ????????';
                          else return null;
                        },
                      ),
                    ]),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  child: Text('????????????????'),
                    onPressed: (){
                      _formKey.currentState?.reset();
                      Navigator.pop(context);
                    }
                ),
                MaterialButton(
                    child: Text('??????????????????'),
                    onPressed: _submit
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}