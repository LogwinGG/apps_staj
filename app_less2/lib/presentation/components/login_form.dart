// ignore_for_file: prefer_const_constructors_in_immutables, prefer_final_fields, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:app_less2/application/main_bloc.dart';
import 'package:app_less2/application/main_bloc_event.dart';
import 'package:app_less2/application/main_bloc_state.dart';
import 'package:app_less2/domain/functions/validate_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  MainBloc bloc = MainBloc();


  void _submit() {
    if (_formKey.currentState!.validate()) {

      _formKey.currentState!.save();

       bloc.add( SignIn(email: _controllerEmail.text ,password: _controllerPassword.text) );
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
                return '''Пароль должен содержать символы верхнего и нижнего регистра латиницой, длиной от 6 до 20 символов''';
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

          MaterialButton(
            color: Colors.white,
            child: const Text('Войти'),
            onPressed: _submit,
          ),

          BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, MainBlocState state) {
              if (state is IsError) return Text('Пользователь с таким логином и паролем не найден', style: TextStyle(color: Colors.redAccent),);
              if(state is UserState) {
                //print(state.user.uid);
                Future.delayed(Duration(milliseconds: 400), () => Navigator.of(context).pushReplacementNamed('/home'));
                return Text('Добро пожаловать ');
              }
              if(state is Loading) return CircularProgressIndicator();
              else  return SizedBox();
            },
          ),
        ],
      ),
    );
  }

}