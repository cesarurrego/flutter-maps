part of 'widgets.dart';

class ManuakMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if( state.manualSelection ){
          return _buildManualMarker(context);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildManualMarker(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Boton regresarr
        Positioned(
            top: 25,
            left: 20,
            child: FadeInLeft(
              duration: Duration( milliseconds: 400),
              child: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.black87),
                  onPressed: () {
                    BlocProvider.of<SearchBloc>(context).add(OnDesactiveteManualMarker());
                  },
                ),
              ),
            )),

        // Marcador
        Center(
          child: Transform.translate(
              offset: Offset(0, -12),
              child: BounceInDown(
                from: 200,
                child: Icon(Icons.location_on, size: 50 ))
              ),
        ),

        // Boton de confirmar
        Positioned(
          bottom: 70,
          left: 60,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 130,
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
              color: Colors.black,
              shape: StadiumBorder(),
              splashColor: Colors.transparent,
              onPressed: () {
                this._caculateDestination(context);
              },
            )
          ),
        )
      ],
    );
  }

  void _caculateDestination(BuildContext context) async {

    calculateAlert(context);

    final trafficService = new TrafficService();
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final init = BlocProvider.of<CurrentLocationBloc>(context).state.location;
    final destination = mapBloc.state.middleLocation;

    //Get destination info
    final reverseQueryResponse = await trafficService.getCoordInfo(destination);

    final trafficResponse = await trafficService.getCoordsInitEnd(init, destination);

    final geometry = trafficResponse.routes[0].geometry;
    final duration = trafficResponse.routes[0].duration;
    final distance = trafficResponse.routes[0].distance;
    final destinationName = reverseQueryResponse.features[0].text;

    // Decode Gometry
    final points = Poly.Polyline.Decode( encodedString: geometry, precision: 6).decodedCoords;
    final List<LatLng> coordsList = points.map(
      (point) => LatLng(point[0], point[1])
    ).toList();

    print(distance);

    mapBloc.add(OnCreateDestinationRoute(coordsList, distance, duration, destinationName));

    Navigator.of(context).pop();

    BlocProvider.of<SearchBloc>(context).add(OnDesactiveteManualMarker());
  }

}
