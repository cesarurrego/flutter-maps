import 'package:flutter/material.dart';
import 'package:maps_app/pages/gps_access_page.dart';
import 'package:maps_app/pages/loading_page.dart';
import 'package:maps_app/pages/maps_page.dart';


final Map<String, Widget Function(BuildContext)> appRoutes = {
  'maps': ( _ ) => MapsPage(),
  'loading': ( _ ) => LoadingPage(),
  'gps_Access': ( _ ) => GPSAccessPage()

};