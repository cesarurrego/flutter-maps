part of 'widgets.dart';

class SearchBar extends StatelessWidget {

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if ( state.manualSelection ){
          return Container();
        }else {
          return FadeInDown(
            duration: Duration( milliseconds: 400 ),
            child: _buildSearchBar(context)
          );
        }
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: width,
      child: GestureDetector(
        onTap: () async {
          final proximity = BlocProvider.of<CurrentLocationBloc>(context).state.location;
          final searchHistory = BlocProvider.of<SearchBloc>(context).state.history;

          final result = await showSearch(
            context: context, 
            delegate: SearchDestination(proximity, searchHistory)
          );
          this._searchReturn(context, result);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          width: double.infinity,
          height: 50,
          child: Text('Where you want to go?', style: TextStyle(color: Colors.black87)),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0,5)
              )
            ]
          ),
        ),
      ),
    );
  }

  Future<void> _searchReturn(BuildContext context, SearchResult result) async {

    if(result.cancel) return;

    if( result.manual ){
      BlocProvider.of<SearchBloc>(context).add(OnActiveteManualMarker());
      return;
    }

    calculateAlert(context);

    final trafficService = TrafficService();
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final location = BlocProvider.of<CurrentLocationBloc>(context).state.location;
    final destination = result.position;

    final drivingResponse = await trafficService.getCoordsInitEnd(location, destination);

    final geometry = drivingResponse.routes[0].geometry;
    final duration = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;
    final destinationName = result.nameDestination;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);

    final List<LatLng> routeCoords = points.decodedCoords.map(
      ( point ) => LatLng(point[0], point[1])
    ).toList();

    mapBloc.add(OnCreateDestinationRoute(routeCoords, distance, duration, destinationName));

    Navigator.of(context).pop();

    // Agrega busqueda al historial
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.add(OnAddHistory(result));

  }
}