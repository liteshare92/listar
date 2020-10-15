import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listar/app_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final _textNameController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textWebsiteController = TextEditingController();
  final _textInfoController = TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusWebsite = FocusNode();
  final _focusInfo = FocusNode();
  final picker = ImagePicker();

  File _image;
  String _validName;
  String _validEmail;
  String _validWebsite;
  String _validInfo;

  @override
  void initState() {
    super.initState();
    _textNameController.text = Application.user.name;
    _textEmailController.text = Application.user.email;
    _textWebsiteController.text = Application.user.link;
    _textInfoController.text = Application.user.description;
  }

  ///On async get Image file
  Future _getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  ///On update image
  Future<void> _update() async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validName = UtilValidator.validate(
        data: _textNameController.text,
      );
      _validEmail = UtilValidator.validate(
        data: _textEmailController.text,
        type: ValidateType.email,
      );
      _validWebsite = UtilValidator.validate(
        data: _textWebsiteController.text,
      );
      _validInfo = UtilValidator.validate(
        data: _textInfoController.text,
      );
    });
    if (_validName == null &&
        _validEmail == null &&
        _validWebsite == null &&
        _validInfo == null) {
      AppBloc.editProfileBloc.add(
        OnChangeProfile(
          name: _textNameController.text,
          email: _textEmailController.text,
          website: _textWebsiteController.text,
          information: _textInfoController.text,
        ),
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
            Translate.of(context).translate('edit_profile'),
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

  ///Build Avatar image
  Widget _buildAvatar() {
    if (_image != null) {
      return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          child: Image.file(
            _image,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: Application.user?.image,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(Icons.error),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, listen) {
        if (listen is EditProfileFail) {
          _showMessage(Translate.of(context).translate(listen.code));
        }
        if (listen is EditProfileSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Translate.of(context).translate('edit_profile')),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: <Widget>[
                            _buildAvatar(),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: _getImage,
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        Translate.of(context).translate('name'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInput(
                      hintText: Translate.of(context).translate('input_name'),
                      errorText: Translate.of(context).translate(_validName),
                      focusNode: _focusName,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textNameController.clear();
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                          context,
                          _focusName,
                          _focusEmail,
                        );
                      },
                      onChanged: (text) {
                        setState(() {
                          _validName = UtilValidator.validate(
                            data: _textNameController.text,
                          );
                        });
                      },
                      icon: Icon(Icons.clear),
                      controller: _textNameController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        Translate.of(context).translate('email'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInput(
                      hintText: Translate.of(context).translate('input_email'),
                      errorText: Translate.of(context).translate(_validEmail),
                      focusNode: _focusEmail,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textEmailController.clear();
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                          context,
                          _focusEmail,
                          _focusWebsite,
                        );
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
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        Translate.of(context).translate('website'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInput(
                      hintText: Translate.of(context).translate(
                        'input_website',
                      ),
                      errorText: Translate.of(context).translate(_validWebsite),
                      focusNode: _focusWebsite,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textWebsiteController.clear();
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                          context,
                          _focusWebsite,
                          _focusInfo,
                        );
                      },
                      onChanged: (text) {
                        setState(() {
                          _validWebsite = UtilValidator.validate(
                            data: _textWebsiteController.text,
                          );
                        });
                      },
                      icon: Icon(Icons.clear),
                      controller: _textWebsiteController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        Translate.of(context).translate('information'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInput(
                      hintText: Translate.of(context).translate(
                        'input_information',
                      ),
                      errorText: Translate.of(context).translate(_validInfo),
                      focusNode: _focusInfo,
                      maxLines: 5,
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textInfoController.clear();
                      },
                      onSubmitted: (text) {
                        _update();
                      },
                      onChanged: (text) {
                        setState(() {
                          _validInfo = UtilValidator.validate(
                            data: _textInfoController.text,
                          );
                        });
                      },
                      icon: Icon(Icons.clear),
                      controller: _textInfoController,
                    ),
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
                child: BlocBuilder<EditProfileBloc, EditProfileState>(
                  builder: (context, state) {
                    return AppButton(
                      onPressed: () {
                        _update();
                      },
                      text: Translate.of(context).translate('confirm'),
                      loading: state is FetchingEditProfile,
                      disableTouchWhenLoading: true,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
