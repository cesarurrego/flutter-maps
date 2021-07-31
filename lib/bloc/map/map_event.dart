part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapReady extends MapEvent{}

class OnDrawRoute extends MapEvent{}

class OnFollowLocation extends MapEvent{}

class OnCreateDestinationRoute extends MapEvent{
  final List<LatLng> routeCoords;
  final double distance;
  final double duration;
  final String destinationName;
  OnCreateDestinationRoute(this.routeCoords, this.distance, this.duration, this.destinationName);  
}

class OnCameraMoved extends MapEvent{
  final LatLng middleMap;
  OnCameraMoved(this.middleMap);
}

class OnNewLocation extends MapEvent{
  final LatLng location;
  OnNewLocation(this.location);
}