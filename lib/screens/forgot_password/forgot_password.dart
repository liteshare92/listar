import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _textEmailController = TextEditingController();

  String _validEmail;

  @override
  void initState() {
    super.initState();
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('forgot_password'),
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

  ///Fetch API
  Future<void> _forgotPassword(BuildContext context) async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validEmail = UtilValidator.validate(
        data: _textEmailController.text,
        type: ValidateType.email,
      );
    });
    if (_validEmail == null) {
      AppBloc.passwordBloc
          .add(OnForgotPassword(email: _textEmailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordFail) {
          _showMessage(Translate.of(context).translate(state.code));
        }
        if (state is ForgotPasswordSuccess) {
          _showMessage(
            Translate.of(context).translate('forgot_password_success'),
          );
        }
      },
      child: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                Translate.of(context).translate('forgot_password'),
              ),
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          Translate.of(context).translate('email'),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      AppTextInput(
                        hintText: Translate.of(context).translate(
                          'input_email',
                        ),
                        errorText: Translate.of(context).translate(_validEmail),
                        onTapIcon: () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          _textEmailController.clear();
                        },
                        onSubmitted: (text) {
                          _forgotPassword(context);
                        },
                        onChanged: (text) {
                          setState(() {
                            _validEmail = UtilValidator.validate(
                              data: _textEmailController.text,
                              type: ValidateType.email,
                            );
                          });
                        },
                        icon: Icon(Icons.clear),
                        controller: _textEmailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      AppButton(
                        onPressed: () {
                          _forgotPassword(context);
                        },
                        text: Translate.of(context).translate('reset_password'),
                        loading: state is FetchingForgotPassword,
                        disableTouchWhenLoading: true,
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
