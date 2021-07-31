import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/bloc/current_location/current_location_bloc.dart';
import 'package:maps_app/bloc/map/map_bloc.dart';
import 'package:maps_app/bloc/search/search_bloc.dart';

import 'package:maps_app/routes/routes.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ( _ ) => CurrentLocationBloc()),
        BlocProvider(create: ( _ ) => MapBloc()),
        BlocProvider(create: ( _ ) => SearchBloc())
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}