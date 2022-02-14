
// ignore_for_file: prefer_typing_uninitialized_variables


import 'package:app_less2/infrastructure/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_less2/application/main_bloc_event.dart';
import 'package:app_less2/application/main_bloc_state.dart';

class MainBloc extends Bloc <MainBlocEvent, MainBlocState> {
  final AuthService _authService = AuthService();

  MainBloc() : super(MainBlocState()) {
    on<SignIn>((event, emit) async {
      emit(Loading());
      try {
        UserState userState = UserState();
        userState.user = await _authService.signIn(event.email, event.password);
        if (userState.user == null) emit(IsError());
        emit(userState);
      } catch (_) {
        emit(IsError());
      }
    });

    on<CreateUser>((event, emit) async {
      emit(Loading());
      try {
        UserState userState = UserState();
        userState.user =
        await _authService.createUser(event.email, event.password);

        if (userState.user == null) {
          emit(IsError());
        } else {
          CollectionReference userCol = FirebaseFirestore.instance.collection(
              '${userState.user.uid}');
          userCol.add({
            'login': event.email,
            'password': event.password
          });
        }
        emit(userState);
      } catch (_) {
        emit(IsError());
      }
    });

    on<SignOut>((event, emit) {
      _authService.signOut();
    });

    on<GetUserData>((event, emit) async {
      emit(Loading());
      try {
        UserDataState userDataState = UserDataState();
        QuerySnapshot userData = await FirebaseFirestore.instance.collection(
            '${_authService
                .getCurrentUser()
                .uid}').get();
        userDataState.userData = userData.docs[0].data();
        emit(userDataState);
      } catch (e) {
        emit(IsError());
      }
    });
  }
}
