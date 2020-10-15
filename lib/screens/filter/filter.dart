import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar/blocs/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/list_repository.dart';
import 'package:listar/screens/screen.dart';
import 'package:listar/utils/utils.dart';

enum TimeType { start, end }

class Filter extends StatefulWidget {
  final ListFilter filter;
  Filter({Key key, this.filter}) : super(key: key);

  @override
  _FilterState createState() {
    return _FilterState();
  }
}

class _FilterState extends State<Filter> {
  final _listRepository = ListRepository();

  bool _loadingArea = false;
  TimeOfDay _startHour = ListSetting.startHour;
  TimeOfDay _endHour = ListSetting.endHour;
  RangeValues _rangeValues;
  List<CategoryModel> _category = [];
  List<CategoryModel> _feature = [];
  String _colorSelected;
  CategoryModel _locationSelected;
  CategoryModel _areaSelected;
  List<CategoryModel> _listArea = [];

  @override
  void initState() {
    if (widget.filter.category.isNotEmpty) {
      _category.addAll(widget.filter.category.map((item) {
        return ListSetting.category
            .firstWhere((check) => check.id == item.id, orElse: () => null);
      }).toList());
    }
    _feature.addAll(widget.filter.feature);
    _areaSelected = widget.filter.location;
    if (widget.filter.minPrice != null && widget.filter.maxPrice != null) {
      _rangeValues = RangeValues(
        widget.filter.minPrice,
        widget.filter.maxPrice,
      );
    }
    _colorSelected = widget.filter.color;
    _startHour = widget.filter.startHour;
    _endHour = widget.filter.endHour;
    super.initState();
  }

  ///Export String hour
  String _labelTime(TimeOfDay time) {
    final String hourLabel = time.hour < 10 ? '0${time.hour}' : '${time.hour}';
    final String minLabel =
        time.minute < 10 ? '0${time.minute}' : '${time.minute}';
    return '$hourLabel:$minLabel';
  }

  ///Show Picker Time
  Future<void> _showTimePicker(BuildContext context, TimeType type) async {
    final picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (type == TimeType.start && picked != null) {
      setState(() {
        _startHour = picked;
      });
    }
    if (type == TimeType.end && picked != null) {
      setState(() {
        _endHour = picked;
      });
    }
  }

  ///On Navigate Filter location
  Future<void> _onNavigateLocation(List<CategoryModel> list) async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.chooseLocation,
      arguments: LocationPicker(
        selected: _locationSelected,
        list: list,
      ),
    );
    if (selected != null) {
      setState(() {
        _locationSelected = selected;
        _loadingArea = true;
      });
      final ResultApiModel result = await _listRepository.getArea(
        {"parent_id": _locationSelected.id},
      );
      if (result.success) {
        final Iterable refactorArea = result?.data ?? [];
        setState(() {
          _listArea = refactorArea.map((item) {
            return CategoryModel.fromJson(item);
          }).toList();
          _loadingArea = false;
        });
      }
    }
  }

  ///On Navigate Filter Area
  Future<void> _onNavigateArea(List<CategoryModel> list) async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.chooseLocation,
      arguments: LocationPicker(
        selected: _areaSelected,
        list: list,
      ),
    );
    if (selected != null) {
      setState(() {
        _areaSelected = selected;
      });
    }
  }

  ///Apply filter
  void _onApply() {
    Navigator.pop(
      context,
      ListFilter(
        category: _category,
        feature: _feature,
        location: _locationSelected,
        minPrice: _rangeValues?.start,
        maxPrice: _rangeValues?.end,
        color: _colorSelected,
        startHour: _startHour,
        endHour: _endHour,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('filter'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              Translate.of(context).translate('apply'),
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
            onPressed: _onApply,
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            ///Success
            if (state is FilterSuccess) {
              String unit = ListSetting.unit;
              Widget location = Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  Translate.of(context).translate('select_location'),
                  style: Theme.of(context).textTheme.caption,
                ),
              );
              Widget area = Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  Translate.of(context).translate('select_location'),
                  style: Theme.of(context).textTheme.caption,
                ),
              );
              if (_locationSelected != null) {
                location = Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    _locationSelected.title,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Theme.of(context).primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
              if (_areaSelected != null) {
                area = Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    _areaSelected.title,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Theme.of(context).primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
              Widget areaAction = RotatedBox(
                quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  textDirection: TextDirection.ltr,
                ),
              );
              if (_loadingArea) {
                areaAction = Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Text(
                                Translate.of(context)
                                    .translate('category')
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: ListSetting.category.map((item) {
                                final selected = _category.contains(item);
                                return SizedBox(
                                  height: 32,
                                  child: FilterChip(
                                    selected: selected,
                                    label: Text(item.title),
                                    onSelected: (value) {
                                      selected
                                          ? _category.remove(item)
                                          : _category.add(item);
                                      setState(() {
                                        _category = _category;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 10,
                                top: 15,
                              ),
                              child: Text(
                                Translate.of(context)
                                    .translate('facilities')
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: ListSetting.features.map((item) {
                                final bool selected = _feature.contains(item);
                                return SizedBox(
                                  height: 32,
                                  child: FilterChip(
                                    selected: selected,
                                    label: Text(item.title),
                                    onSelected: (value) {
                                      selected
                                          ? _feature.remove(item)
                                          : _feature.add(item);
                                      setState(() {
                                        _feature = _feature;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 15,
                              ),
                              child: InkWell(
                                onTap: () {
                                  _onNavigateLocation(ListSetting.locations);
                                },
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                Translate.of(context)
                                                    .translate('location')
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              location,
                                            ],
                                          ),
                                        ),
                                      ),
                                      RotatedBox(
                                        quarterTurns:
                                            UtilLanguage.isRTL() ? 2 : 0,
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _locationSelected != null ||
                                  _areaSelected != null,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 15,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _onNavigateArea(_listArea);
                                  },
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  Translate.of(context)
                                                      .translate('area')
                                                      .toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                area,
                                              ],
                                            ),
                                          ),
                                        ),
                                        areaAction,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    Translate.of(context)
                                        .translate('price_range')
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${ListSetting.priceMin}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        Text(
                                          '${ListSetting.priceMax}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 20,
                          child: RangeSlider(
                            min: ListSetting.priceMin.toDouble(),
                            max: ListSetting.priceMax.toDouble(),
                            values: _rangeValues ??
                                RangeValues(
                                  ListSetting.priceMin.toDouble(),
                                  ListSetting.priceMax.toDouble(),
                                ),
                            onChanged: (range) {
                              setState(() {
                                _rangeValues = range;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              Translate.of(context).translate('avg_price'),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            _rangeValues != null
                                ? Text(
                                    '${_rangeValues.start.round()} $unit- ${_rangeValues.end.round()} $unit',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 10,
                                top: 15,
                              ),
                              child: Text(
                                Translate.of(context)
                                    .translate('business_color')
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Wrap(
                              spacing: 15,
                              runSpacing: 10,
                              children: ListSetting.color.map((item) {
                                final bool selected = _colorSelected == item;
                                Widget checked = Container();
                                if (selected) {
                                  checked = Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  );
                                }
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _colorSelected = item;
                                    });
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UtilColor.getColorFromHex(item),
                                    ),
                                    child: checked,
                                  ),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 10,
                                top: 15,
                              ),
                              child: Text(
                                Translate.of(context)
                                    .translate('open_time')
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          _showTimePicker(
                                              context, TimeType.start);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Translate.of(context).translate(
                                                'start_time',
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              _labelTime(_startHour),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: InkWell(
                                          onTap: () {
                                            _showTimePicker(
                                                context, TimeType.end);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                Translate.of(context).translate(
                                                  'end_time',
                                                ),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                _labelTime(_endHour),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LocationPicker {
  final CategoryModel selected;
  final List<CategoryModel> list;
  LocationPicker({this.selected, this.list});
}
