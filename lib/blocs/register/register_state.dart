abstract class RegisterState {}

class InitialRegisterState extends RegisterState {}

class FetchingRegister extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFail extends RegisterState {
  final String code;
  RegisterFail({this.code});
}
