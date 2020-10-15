class Images {
  static const String Intro1 = "assets/images/intro_1.png";
  static const String Intro2 = "assets/images/intro_2.png";
  static const String Intro3 = "assets/images/intro_3.png";
  static const String Logo = "assets/images/logo.png";
  static const String Slide = "assets/images/slide.png";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
