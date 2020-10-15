abstract class EditProfileEvent {}

class OnChangeProfile extends EditProfileEvent {
  String name;
  String email;
  String website;
  String information;
  OnChangeProfile({this.name, this.email, this.website, this.information});
}
