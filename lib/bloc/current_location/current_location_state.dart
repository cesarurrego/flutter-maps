part of 'current_location_bloc.dart';

@immutable
class CurrentLocationState {

  final bool following;
  final bool haveLocation;
  final LatLng location;

  CurrentLocationState({
    this.following = true, 
    this.haveLocation = false, 
    this.location
  });

  CurrentLocationState copyWith({
    bool following,
    bool haveLocation,
    LatLng location,
  }) => new CurrentLocationState(
    following    : following ?? this.following,
    haveLocation : haveLocation ?? this.haveLocation,
    location     : location ?? this.location
  );

}