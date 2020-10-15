import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/application.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/screens/screen.dart';
import 'package:listar/utils/logger.dart';
import 'package:listar/utils/utils.dart';

class MainNavigation extends StatefulWidget {
  MainNavigation({Key key}) : super(key: key);

  @override
  _MainNavigationState createState() {
    return _MainNavigationState();
  }
}

class _MainNavigationState extends State<MainNavigation> {
  final _fcm = FirebaseMessaging();
  int _selectedIndex = 0;

  @override
  void initState() {
    _fcmHandle();
    super.initState();
  }

  ///Support Notification listen
  void _fcmHandle() async {
    await Future.delayed(Duration(seconds: 2));
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['aps']['alert'];
        UtilLogger.log("onMessage", '$notification');
        _showNotification(notification['title'], notification['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        final notification = message['aps']['alert'];
        _showNotification(notification['title'], notification['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['aps']['alert'];
        _showNotification(notification['title'], notification['body']);
        UtilLogger.log("onResume", 'onMessage $message');
      },
    );
    Application.pushToken = await _fcm.getToken();
  }

  ///On change tab bottom menu
  void _onItemTapped({int index, bool requireLogin}) async {
    if (requireLogin && (index == 1 || index == 2)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: index == 1 ? Routes.wishList : Routes.account,
      );
      switch (result) {
        case Routes.wishList:
          index = 1;
          break;
        case Routes.account:
          index = 2;
          break;
        default:
          return;
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  ///Show notification received
  Future<void> _showNotification(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(Translate.of(context).translate('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///List bottom menu
  List<BottomNavigationBarItem> _bottomBarItem(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: Translate.of(context).translate('home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bookmark),
        label: Translate.of(context).translate('wish_list'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: Translate.of(context).translate('account'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is AuthenticationFail &&
            (_selectedIndex == 1 || _selectedIndex == 2)) {
          final result = await Navigator.pushNamed(
            context,
            Routes.signIn,
            arguments: _selectedIndex == 1 ? Routes.wishList : Routes.account,
          );
          if (result == null) {
            setState(() {
              _selectedIndex = 0;
            });
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthenticationState>(
        builder: (context, state) {
          final requireLogin = state is AuthenticationFail;
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[Home(), WishList(), Profile()],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _bottomBarItem(context),
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              selectedItemColor: Theme.of(context).primaryColor,
              showUnselectedLabels: true,
              onTap: (index) {
                _onItemTapped(index: index, requireLogin: requireLogin);
              },
            ),
          );
        },
      ),
    );
  }
}
