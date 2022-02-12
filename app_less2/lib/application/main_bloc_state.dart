class MainBlocState {}

class UserDataState extends MainBlocState{
  Map<String, dynamic> userData = {};
}

class UserState extends MainBlocState{
  // ignore: prefer_typing_uninitialized_variables
  late var user;
}

class Loading extends MainBlocState{}
class IsError extends MainBlocState{}
class LogOut extends MainBlocState{}