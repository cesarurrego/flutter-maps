import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:maps_app/models/search_result.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState( SearchEvent event ) async* {
    
    if( event is OnActiveteManualMarker){
      yield state.copyWith(manualSelection: true);
    }else if (event is OnDesactiveteManualMarker){
      yield state.copyWith(manualSelection: false);
    }else if (event is OnAddHistory){
      final exist = state.history.where(
        (result) => result.nameDestination == event.result.nameDestination
      ).length;

      if(exist == 0){
        final newHistory = [...state.history, event.result];
        yield state.copyWith(history: newHistory);
      }
    }

  }
}
