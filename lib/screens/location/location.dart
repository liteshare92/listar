import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:listar/models/model.dart';
import 'package:listar/utils/utils.dart';

class Location extends StatefulWidget {
  final LocationModel location;

  Location({
    Key key,
    this.location,
  }) : super(key: key);

  @override
  _LocationState createState() {
    return _LocationState();
  }
}

class _LocationState extends State<Location> {
  CameraPosition _initPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    _onLoadMap();
    super.initState();
  }

  ///On load map
  void _onLoadMap() {
    final MarkerId markerId = MarkerId(widget.location.name);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(widget.location.latitude, widget.location.longitude),
      infoWindow: InfoWindow(title: widget.location.name),
      onTap: () {},
    );

    setState(() {
      _initPosition = CameraPosition(
        target: LatLng(widget.location.latitude, widget.location.longitude),
        zoom: 14.4746,
      );
      _markers[markerId] = marker;
    });
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
      body: Container(
        child: GoogleMap(
          initialCameraPosition: _initPosition,
          markers: Set<Marker>.of(_markers.values),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
