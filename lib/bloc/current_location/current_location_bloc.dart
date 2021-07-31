import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'current_location_event.dart';
part 'current_location_state.dart';

class CurrentLocationBloc extends Bloc<CurrentLocationEvent, CurrentLocationState> {
  
  CurrentLocationBloc() : super(CurrentLocationState());
  StreamSubscription<Position> _positionSubscription;

  void initFollowing(){

    this._positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10
    ).listen((Position position) {
      if(position != null){
        final location = new LatLng(position.latitude, position.longitude);
        add(OnLocationChange(location));
      }
    });

  }

  void finishFollowing(){
    this._positionSubscription?.cancel();
  }

  @override
  Stream<CurrentLocationState> mapEventToState( CurrentLocationEvent event, ) async* {
    if( event is OnLocationChange ){
      yield state.copyWith(
        haveLocation: true,
        location: event.location
      );
    }
  }
}
