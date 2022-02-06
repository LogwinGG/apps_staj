// ignore_for_file: prefer_const_constructors_in_immutables, prefer_final_fields, prefer_const_constructors

import 'package:dialog_screen/auth_service.dart';
import 'package:dialog_screen/functions/validate_function.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isObscureText = true;
  bool _isSuccessMessage = false;
  bool _isErrorAuth = false;

  AuthService _authService = AuthService();



  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() { _isErrorAuth = false; });

      var user = await _authService.signIn(_controllerEmail.text, _controllerPassword.text);

      if (user != null) {
        _formKey.currentState!.reset();

        setState(() { _isSuccessMessage = true; });

        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() { _isErrorAuth = true; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controllerEmail,
            validator: (value) {
              if (value == '') return 'Введите email';
              if (!validateEmail(value!)) {
                return 'Поле email заполнено не корректно';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _controllerPassword,
            validator: (value) {
              if (value == '') return 'Введите пароль';
              if (!validatePassword(value!)) {
                return '''Пароль должен быть на латинеце, длиной от 6 до 20 символов''';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: 'Пароль',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureText = !_isObscureText;
                    });
                  },
                )),
            keyboardType: TextInputType.text,
            obscureText: _isObscureText,
          ),

          _isErrorAuth? Text('Пользователь с таким логином и паролем не найден' ,style: TextStyle(color: Colors.redAccent),): Text(''),

          MaterialButton(
            color: Colors.white,
            child: const Text('Войти'),
            onPressed: _submit,
          ),
          if (_isSuccessMessage) const Text('Добро пожаловать'),
        ],
      ),
    );
  }

}