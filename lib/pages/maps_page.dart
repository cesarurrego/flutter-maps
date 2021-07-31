import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/bloc/current_location/current_location_bloc.dart';
import 'package:maps_app/bloc/map/map_bloc.dart';
import 'package:maps_app/widgets/widgets.dart';

class MapsPage extends StatefulWidget {

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {

  @override
  void initState() {    
    context.read<CurrentLocationBloc>().initFollowing();
    super.initState();
  }

  @override
  void dispose() {
    context.read<CurrentLocationBloc>().finishFollowing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<CurrentLocationBloc, CurrentLocationState>(
              builder: (context, state) => buildMap(state),
            ),
            Positioned(
              top: 10,
              child: SearchBar()
            ),
            ManuakMarker()
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnLocation(),
          BtnFollowLocation(),
          BtnMyRoute()
        ],
      ),
    );
  }

  Widget buildMap(CurrentLocationState state){

    if( !state.haveLocation ) return Center(child: Text('Locating...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    mapBloc.add(OnNewLocation(state.location));

    final cameraPosition = CameraPosition(
      target: state.location,
      zoom: 15
    );

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, _) {
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: mapBloc.initMap,
          polylines: mapBloc.state.polylines.values.toSet(),
          markers: mapBloc.state.markers.values.toSet(),
          onCameraMove: (position) {
            mapBloc.add(OnCameraMoved( position.target ));
          },
        );
      },
    );
  }
}