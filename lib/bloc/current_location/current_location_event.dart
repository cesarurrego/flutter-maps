part of 'current_location_bloc.dart';

@immutable
abstract class CurrentLocationEvent {}

class OnLocationChange extends CurrentLocationEvent{

  final LatLng location;
  
  OnLocationChange(this.location);

}
