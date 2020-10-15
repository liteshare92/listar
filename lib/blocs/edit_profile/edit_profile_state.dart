abstract class EditProfileState {}

class InitialEditProfileState extends EditProfileState {}

class FetchingEditProfile extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {}

class EditProfileFail extends EditProfileState {
  String code;
  EditProfileFail({this.code});
}
