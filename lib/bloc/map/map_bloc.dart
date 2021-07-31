import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helper/helpers.dart';
import 'package:meta/meta.dart';

import 'package:maps_app/themes/uber_map_theme.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  // Map Controller
  GoogleMapController _mapController;

  Polyline _myRoute = new Polyline(
    polylineId: PolylineId('myRuta'),
    width: 4,
    color: Colors.transparent
  );

  Polyline _destinationRoute = new Polyline(
    polylineId: PolylineId('destinationRoute'),
    width: 4,
    color: Colors.black87
  );

  void initMap(GoogleMapController controller){

    if( !state.mapReady ){
      this._mapController = controller;
    
      this._mapController.setMapStyle( jsonEncode(uberMapThene) );
    
      add(OnMapReady());
    }
  }

  void moveCamera( LatLng destination){
    final cameraUpdate = CameraUpdate.newLatLng(destination);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {

    print(event);

    if( event is OnMapReady ){
      yield state.copyWith(mapReady: true);
    } else if( event is OnNewLocation ){
      yield* this._onNewLocation(event);
    } else if( event is OnDrawRoute ){
      yield* this._onDrawRoute(event);      
    } else if( event is OnFollowLocation){
      yield* this._onFollowLocation();
    } else if( event is OnCameraMoved ){
      yield state.copyWith( middleLocation: event.middleMap );
    } else if( event is OnCreateDestinationRoute ){
       yield* this._onCreateRoute(event);
    }
  }

  Stream<MapState> _onNewLocation(OnNewLocation event) async* {
    if(state.followLocation){
      this.moveCamera(event.location);
    }
    final points = [ ...this._myRoute.points, event.location ];
    this._myRoute = this._myRoute.copyWith(pointsParam: points);
    final currentPolylines = state.polylines;
    currentPolylines['myRoute'] = this._myRoute;
    yield state.copyWith(polylines: state.polylines);
  }

  Stream<MapState> _onDrawRoute(OnDrawRoute event) async* {
    if(!state.drawRoute){
      this._myRoute = this._myRoute.copyWith( colorParam: Colors.black87);
    }else{
      this._myRoute = this._myRoute.copyWith( colorParam: Colors.transparent);
    }

    final currentPolylines = state.polylines;
    currentPolylines['myRoute'] = this._myRoute;

    yield state.copyWith(
      drawRoute: !state.drawRoute,
      polylines: currentPolylines
    );
  }

  Stream<MapState> _onFollowLocation() async*{
    if( !state.followLocation ){
      this.moveCamera(this._myRoute.points[this._myRoute.points.length -1]);
    }
    yield state.copyWith(followLocation: !state.followLocation);
  }

  Stream<MapState> _onCreateRoute(OnCreateDestinationRoute event) async*{

    this._destinationRoute = this._destinationRoute.copyWith(
      pointsParam: event.routeCoords
    );

    final currentPolylines = state.polylines;
    currentPolylines['destinationRoute'] = this._destinationRoute;

    final minutes = (event.duration / 60 ).floor();

    // Icono
    //final initialIcon = await getAssetImageMarker();
    final initialIcon = await getInitialMarkerIcon(minutes);

    final markerInitial = new Marker(
      anchor: Offset(0.0, 1.0),
      markerId: MarkerId('initial'),
      position: event.routeCoords[0],     
      icon: initialIcon,
    );

    // double kilometers = event.distance / 1000;
    // kilometers = (kilometers * 100).floorToDouble();
    // kilometers = kilometers/100;

    // final destinationIcon = await getNetworkImageMarker();
    final destinationIcon = await getDestinationMarkerIcon(event.destinationName, event.distance);

    final markerDestination = new Marker(
      anchor: Offset(0.1, 0.9),
      markerId: MarkerId('destination'),
      position: event.routeCoords[event.routeCoords.length-1],
      icon: destinationIcon,

    );

    final newMarkers = { ...state.markers };
    newMarkers['initial'] = markerInitial;
    newMarkers['destination'] = markerDestination;

    Future.delayed(Duration(milliseconds: 300)).then(
      (value) {
        _mapController.showMarkerInfoWindow(MarkerId('destination'));
      }
    );

    yield state.copyWith(
      drawRoute: true,
      polylines: currentPolylines,
      markers: newMarkers
    );
  }
}
