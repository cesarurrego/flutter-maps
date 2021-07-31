import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/helper/helpers.dart';
import 'package:polyline/polyline.dart' as Poly;

import 'package:maps_app/bloc/current_location/current_location_bloc.dart';
import 'package:maps_app/bloc/map/map_bloc.dart';
import 'package:maps_app/bloc/search/search_bloc.dart';

import 'package:maps_app/models/search_result.dart';

import 'package:maps_app/search/search_destination.dart';
import 'package:maps_app/services/traffic_service.dart';

part 'btn_follow_location.dart';
part 'btn_location.dart';
part 'btn_myroute.dart';
part 'manual_marker.dart';
part 'search_bar.dart';

