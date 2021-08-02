import 'dart:async';

import 'package:dio/dio.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/helper/debouncer.dart';
import 'package:maps_app/models/reverse_query_response.dart';

import 'package:maps_app/models/search_response.dart';
import 'package:maps_app/models/traffic_response.dart';

class TrafficService {

  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService(){
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400 ));

  final _suggestionStreamController = new StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get suggestionStream => this._suggestionStreamController.stream;

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey = 'ApiKey';

  void dispose() {
    this._suggestionStreamController.close();
  }

  Future<TrafficRespnse> getCoordsInitEnd(LatLng init, LatLng destination) async {
  
    final coordsString = '${ init.longitude },${ init.latitude };${ destination.longitude },${ destination.latitude }';
    final url = '${this._baseUrlDir}/mapbox/driving/$coordsString';

    final resp = await this._dio.get( '$url', queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey
    });

    final data = TrafficRespnse.fromJson(resp.data);

    return data;

  }

  Future<ReverseQueryResponse> getCoordInfo(LatLng location) async {
      final url = '${ this._baseUrlGeo }/mapbox.places/${ location.longitude },${ location.latitude }.json';
      final resp = await this._dio.get( url, queryParameters: {
        'access_token': this._apiKey,
      });
      final data = reverseQueryResponseFromJson( resp.data );
      return data;
  }

  Future<SearchResponse> getQueryResults( String query, LatLng proximity) async {
    try {
      final url = '${ this._baseUrlGeo }/mapbox.places/$query.json';
      final resp = await this._dio.get( url, queryParameters: {
        'access_token': this._apiKey,
        'autocomplete': 'true',
        'proximity': '${ proximity.longitude },${ proximity.latitude }',
      });      
      final searchResponse = searchResponseFromJson( resp.data );
      return searchResponse;
    } catch (e) {
      return SearchResponse( features: [] );
    }
  }

  void getSuggestionByQuery( String query, LatLng proximidad ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await this.getQueryResults(value, proximidad);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = query;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel()); 

  }

}