// ignore_for_file: prefer_final_fields

import 'package:app_less2/auth_service.dart';
import 'package:app_less2/functions/validate_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();

  AuthService _authService = AuthService();


  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User? user = await _authService.createUser(_controllerEmail.text, _controllerPassword.text);


      CollectionReference userCol = FirebaseFirestore.instance.collection('${user?.uid}');
      userCol.add({
        'login': _controllerEmail.text,
        'password': _controllerPassword.text
      });

      _formKey.currentState!.reset();
      setState(() {
        _isSuccessMessage = true;
      });
      if (user != null) Navigator.of(context).pushReplacementNamed('/home');

    }
  }

  bool _isObscureText = true;
  bool _isSuccessMessage = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controllerEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == '') return 'Заполните поле email';
              if (!validateEmail(value!)) {
                return 'Поле email заполнено не корректно';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _controllerPassword,
            validator: (value) {
              if (value == '') return 'Введите пароль';
              if (!validatePassword(value!)) {
                return '''Пароль должен содержать символы верхнего и 
нижнего регистра латиницой, длиной от 6 до 20
символов''';
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
          TextFormField(
            validator: (value) {
              if (value == '') return 'Подтвердите пароль';
              if (value != _controllerPassword.text) {
                return 'Пароли не совпадают';
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: 'Подтвердите пароль',
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
          MaterialButton(
            color: Colors.white,
            child: const Text('Зарегистрироваться и войти'),
            onPressed: _submit,
          ),
          if (_isSuccessMessage) const Text('Вы успешно зарегистрировались')
        ],
      ),
    );
  }

}
