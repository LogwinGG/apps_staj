class MainBlocEvent{}

class SignIn extends MainBlocEvent {
  final String email;
  final String password;

  SignIn({required this.email, required this.password});
}

class CreateUser extends MainBlocEvent {
  final String email;
  final String password;

  CreateUser({required this.email, required this.password});
}

class SignOut extends MainBlocEvent {}

class GetUserData extends MainBlocEvent {}