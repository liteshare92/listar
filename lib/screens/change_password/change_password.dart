import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  final _textPassController = TextEditingController();
  final _textRePassController = TextEditingController();
  final _focusPass = FocusNode();
  final _focusRePass = FocusNode();

  String _validPass;
  String _validRePass;

  @override
  void initState() {
    super.initState();
  }

  ///On change password
  Future<void> _changePassword(BuildContext context) async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validPass = UtilValidator.validate(
        data: _textPassController.text,
      );
      _validRePass = UtilValidator.validate(
          data: _textRePassController.text, match: _textPassController.text);
    });
    if (_validPass == null && _validRePass == null) {
      AppBloc.passwordBloc.add(
        OnChangePassword(password: _textPassController.text),
      );
    }
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('change_password'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                Translate.of(context).translate('close'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordFail) {
          _showMessage(Translate.of(context).translate(state.code));
        }
        if (state is ChangePasswordSuccess) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                Translate.of(context).translate('change_password'),
              ),
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          Translate.of(context).translate('password'),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      AppTextInput(
                        hintText: Translate.of(context).translate(
                          'input_your_password',
                        ),
                        errorText: Translate.of(context).translate(_validPass),
                        focusNode: _focusPass,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        onTapIcon: () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          _textPassController.clear();
                        },
                        onSubmitted: (text) {
                          UtilOther.fieldFocusChange(
                            context,
                            _focusPass,
                            _focusRePass,
                          );
                        },
                        onChanged: (text) {
                          setState(() {
                            _validPass = UtilValidator.validate(
                              data: _textPassController.text,
                            );
                          });
                        },
                        icon: Icon(Icons.clear),
                        controller: _textPassController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          Translate.of(context).translate('confirm_password'),
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      AppTextInput(
                        hintText: Translate.of(context).translate(
                          'confirm_your_password',
                        ),
                        errorText: Translate.of(context).translate(
                          _validRePass,
                        ),
                        focusNode: _focusRePass,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        onTapIcon: () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          _textRePassController.clear();
                        },
                        onSubmitted: (text) {
                          _changePassword(context);
                        },
                        onChanged: (text) {
                          setState(() {
                            _validRePass = UtilValidator.validate(
                              data: _textRePassController.text,
                            );
                          });
                        },
                        icon: Icon(Icons.clear),
                        controller: _textRePassController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: AppButton(
                          onPressed: () {
                            _changePassword(context);
                          },
                          text: Translate.of(context).translate('confirm'),
                          loading: state is FetchingChangePassword,
                          disableTouchWhenLoading: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
