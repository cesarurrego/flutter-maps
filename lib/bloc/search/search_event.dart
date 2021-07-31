part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class OnActiveteManualMarker extends SearchEvent{}

class OnDesactiveteManualMarker extends SearchEvent{}

class OnAddHistory extends SearchEvent{
  
  final SearchResult result;
  OnAddHistory(this.result);

}
