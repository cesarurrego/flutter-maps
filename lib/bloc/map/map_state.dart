part of 'map_bloc.dart';

@immutable
class MapState {

  final bool mapReady;
  final bool drawRoute;
  final bool followLocation;
  final LatLng middleLocation;
  
  // Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapState({
    this.mapReady = false,
    this.drawRoute = false,
    this.followLocation = false,
    this.middleLocation,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers
  }): this.polylines = polylines ?? new Map(),
      this.markers = markers ?? new Map();

  MapState copyWith({
    bool mapReady,
    bool drawRoute,
    bool followLocation,
    LatLng middleLocation,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers
  }) => MapState(
    mapReady: mapReady ?? this.mapReady,
    drawRoute: drawRoute ?? this.drawRoute,
    followLocation: followLocation ?? this.followLocation,
    middleLocation: middleLocation ?? this.middleLocation,
    polylines: polylines ?? this.polylines,
    markers: markers ?? this.markers
  );

}
