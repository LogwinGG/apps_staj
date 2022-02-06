

import 'package:dialog_screen/components/login_form.dart';
import 'package:dialog_screen/components/register_form.dart';
import 'package:flutter/material.dart';


enum FormType { login, register }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FormType _formType = FormType.login;

  _switchForm() {
    setState(() {
      _formType =
          _formType == FormType.login ? FormType.register : FormType.login;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formType == FormType.login ? 'Вход' : 'Регистрация',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    _formType == FormType.login ? LoginForm() :  RegisterForm(),
                  ],
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _formType != FormType.login
                        ? 'Уже есть аккаунт?'
                        : 'Еще нет аккаунта?',
                  ),
                  MaterialButton(
                    child: Text(
                        _formType != FormType.login ? 'Войти' : 'Регистрация',
                        style: Theme.of(context).textTheme.bodyText1),
                    onPressed: _switchForm,
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
