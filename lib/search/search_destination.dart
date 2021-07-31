import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/models/search_response.dart';
import 'package:maps_app/models/search_result.dart';
import 'package:maps_app/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult>{

  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximity;
  final List<SearchResult> searchHistory;

  SearchDestination(this.proximity, this.searchHistory) 
    : this.searchFieldLabel = 'Search...',
      this._trafficService = new TrafficService();  

  @override
  List<Widget> buildActions(BuildContext context) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed:() => this.query = ''
        )
      ];
  } 
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed:() => this.close(context, SearchResult(cancel: true)), 
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    return this._buildSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(this.query.isEmpty){
      return ListView(
        children: [
          ListTile(
            leading: Icon( Icons.location_on ),
            title: Text('Put location manually'),
            onTap: () {
              this.close(context, SearchResult(cancel: false, manual: true));
            },
          ),
          ...this.searchHistory.map(
            (result) => ListTile(
              leading: Icon(Icons.history),
              title: Text( result.nameDestination ),
              subtitle: Text( result.description ),
              onTap: () {
                this.close(context, result);
              },
            )
          ).toList()
        ],
      );
    }

    return this._buildSuggestions();
  }

  Widget _buildSuggestions(){

    if( this.query.isEmpty ){
      return Container();
    }

    this._trafficService.getSuggestionByQuery(this.query.trim(), proximity);

    return StreamBuilder(
      stream: this._trafficService.suggestionStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) { 
        if( !snapshot.hasData ){
          return Center(child: CircularProgressIndicator());
        }

        print(snapshot.data);

        final locations = snapshot.data.features;

        if( locations.length == 0 ){
          return ListTile(
            title: Text('No results with ${this.query}'),
          );
        }

        return ListView.separated(
          itemCount: locations.length,
          separatorBuilder: ( _ , i ) => Divider(),
          itemBuilder: ( _ , i ){
            final location = locations[i];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text( location.text ),
              subtitle: Text( location.placeName ),
              onTap: (){
                this.close(context, SearchResult(
                  cancel: false, 
                  manual: false,
                  position: LatLng(location.center[1], location.center[0]),
                  nameDestination: location.text,
                  description: location.placeName
                ));
              },
            );
          },
        );
      },
    );
  }

}