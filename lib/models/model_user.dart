class UserModel {
  int id;
  String name;
  String nickname;
  String image;
  String link;
  int level;
  String description;
  String tag;
  double rate;
  String token;
  String email;

  UserModel(
    this.id,
    this.name,
    this.nickname,
    this.image,
    this.link,
    this.level,
    this.description,
    this.tag,
    this.rate,
    this.token,
    this.email,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        json['id'] as int ?? 0,
        json['display_name'] as String ?? 'Unknown',
        json['user_nicename'] as String ?? 'Unknown',
        json['user_photo'] as String ?? 'Unknown',
        json['user_url'] as String ?? 'Unknown',
        json['user_level'] as int ?? 0,
        json['description'] as String ?? 'Unknown',
        json['tag'] as String ?? 'Unknown',
        json['rate'] as double ?? 0.0,
        json['token'] as String ?? 'Unknown',
        json['user_email'] as String ?? 'Unknown',
      );
    } catch (error) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': name,
      'user_nicename': nickname,
      'user_photo': image,
      'user_url': link,
      'user_level': level,
      'description': description,
      'tag': tag,
      'rate': rate,
      'token': token,
      'user_email': email
    };
  }
}
