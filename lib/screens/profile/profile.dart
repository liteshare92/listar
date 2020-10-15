import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  ///On logout
  Future<void> _logout() async {
    AppBloc.loginBloc.add(OnLogout());
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('profile'),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationSuccess) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(
                        top: 15,
                      ),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: AppUserInfo(
                            user: Application.user,
                            onPressed: () {},
                            type: AppUserType.information,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                          child: Column(
                            children: <Widget>[
                              AppListTitle(
                                title: Translate.of(context).translate(
                                  'edit_profile',
                                ),
                                trailing: RotatedBox(
                                  quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ),
                                onPressed: () {
                                  _onNavigate(Routes.editProfile);
                                },
                              ),
                              AppListTitle(
                                title: Translate.of(context).translate(
                                  'change_password',
                                ),
                                trailing: RotatedBox(
                                  quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ),
                                onPressed: () {
                                  _onNavigate(Routes.changePassword);
                                },
                              ),
                              AppListTitle(
                                title:
                                    Translate.of(context).translate('setting'),
                                onPressed: () {
                                  _onNavigate(Routes.setting);
                                },
                                trailing: RotatedBox(
                                  quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ),
                                border: false,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                      bottom: 15,
                    ),
                    child: AppButton(
                      onPressed: _logout,
                      text: Translate.of(context).translate('sign_out'),
                    ),
                  )
                ],
              );
            }

            return ListView(
              padding: EdgeInsets.only(
                top: 15,
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: AppUserInfo(type: AppUserType.information),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).hoverColor,
                    highlightColor: Theme.of(context).highlightColor,
                    enabled: true,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 40,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 16),
                        ),
                        Container(
                          height: 40,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 16),
                        ),
                        Container(
                          height: 40,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 16),
                        ),
                        Container(
                          height: 40,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 16),
                        ),
                        Container(
                          height: 40,
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
