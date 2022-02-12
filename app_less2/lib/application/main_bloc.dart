
// ignore_for_file: prefer_typing_uninitialized_variables


import 'package:app_less2/infrastructure/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_less2/application/main_bloc_event.dart';
import 'package:app_less2/application/main_bloc_state.dart';

class MainBloc extends Bloc <MainBlocEvent, MainBlocState> {
  MainBloc() : super(MainBlocState());
  final AuthService _authService = AuthService();

  @override
  Stream<MainBlocState> mapEventToState(MainBlocEvent event) async* {
    if (event is SignIn) {
      yield Loading();
      try {
        UserState userState = UserState();
        userState.user = await _authService.signIn(event.email, event.password);
        if (userState.user == null) yield IsError();
        yield userState;
      } catch (_) {
        yield IsError();
      }

    } else if (event is CreateUser) {
      yield Loading();
      try {
        UserState userState = UserState();
        userState.user = await _authService.createUser(event.email, event.password);

        if (userState.user == null) {
          yield IsError();
        } else {
          CollectionReference userCol = FirebaseFirestore.instance.collection('${userState.user.uid}');
          userCol.add({
            'login': event.email,
            'password': event.password
          });
        }

        yield userState;

      } catch (_) {
        yield IsError();
      }

    } else if (event is SignOut) {
      _authService.signOut();

    } else if (event is GetUserData) {
      yield Loading();
      try {
        UserDataState userDataState = UserDataState();
        QuerySnapshot userData = await FirebaseFirestore.instance.collection('${_authService.getCurrentUser().uid}').get();
        userDataState.userData = userData.docs[0].data();
        yield userDataState;
      }catch (e){
        yield IsError();
      }
    }
  }
}
