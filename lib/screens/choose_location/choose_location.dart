import 'package:flutter/material.dart';
import 'package:listar/models/model.dart';
import 'package:listar/screens/screen.dart';
import 'package:listar/utils/utils.dart';
import 'package:listar/widgets/widget.dart';

class ChooseLocation extends StatefulWidget {
  final LocationPicker location;

  ChooseLocation({Key key, this.location}) : super(key: key);

  @override
  _ChooseLocationState createState() {
    return _ChooseLocationState();
  }
}

class _ChooseLocationState extends State<ChooseLocation> {
  final _textLocationController = TextEditingController();

  String _keyword = '';
  CategoryModel _locationSelected;

  @override
  void initState() {
    _locationSelected = widget.location.selected;
    super.initState();
  }

  ///On Select Location
  void _onSelect(CategoryModel item) {
    setState(() {
      _locationSelected = item;
    });
  }

  ///On Filter Location
  void _onFilter(String text) {
    setState(() {
      _keyword = text;
    });
  }

  ///On change location
  Future<void> _onChange() async {
    UtilOther.hiddenKeyboard(context);
    Navigator.pop(context, _locationSelected);
  }

  Widget _buildList() {
    if (widget.location.list.isEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.sentiment_satisfied),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                Translate.of(context).translate(
                  'location_is_empty',
                ),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      );
    }
    List<CategoryModel> location = widget.location.list;

    ///Filter
    if (_keyword.isNotEmpty) {
      location = location.where(((item) {
        return item.title.toUpperCase().contains(_keyword.toUpperCase());
      })).toList();
    }

    ///Build List
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
            bottom: 15,
          ),
          child: AppTextInput(
            hintText: Translate.of(context).translate('search'),
            onChanged: _onFilter,
            onSubmitted: _onFilter,
            icon: Icon(Icons.clear),
            controller: _textLocationController,
            onTapIcon: () async {
              await Future.delayed(Duration(milliseconds: 100));
              _textLocationController.clear();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(left: 20, right: 20),
            itemBuilder: (context, index) {
              final item = location[index];
              final trailing = _locationSelected == item
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )
                  : null;
              return AppListTitle(
                title: item.title,
                textStyle: trailing != null
                    ? Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).primaryColor)
                    : null,
                trailing: trailing,
                onPressed: () {
                  _onSelect(item);
                },
              );
            },
            itemCount: location.length,
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
            onPressed: () {
              _onChange();
            },
            text: Translate.of(context).translate('apply'),
            disableTouchWhenLoading: true,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('location'),
        ),
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }
}
