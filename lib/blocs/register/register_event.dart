abstract class RegisterEvent {}

class OnRegister extends RegisterEvent {
  final String username;
  final String password;
  final String email;
  OnRegister({this.username, this.password, this.email});
}
