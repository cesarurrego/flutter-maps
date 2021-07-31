import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:maps_app/helper/helpers.dart';

import 'package:maps_app/pages/gps_access_page.dart';
import 'package:maps_app/pages/maps_page.dart';


class LoadingPage extends StatefulWidget {

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.resumed){
      if(await Geolocator.isLocationServiceEnabled()){
        Navigator.pushReplacement(context, navigateMapFadeIn(context, MapsPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return Center(
              child: Text(snapshot.data)
            );
          }else{
            return Center(
              child: CircularProgressIndicator(strokeWidth: 2,), 
            );
          }
        },
      ),
   );
  }

  Future checkGpsLocation(BuildContext context) async{

    // var gpsPermission;
    // var gpsActive;

    final gpsPermission = await Permission.location.isGranted;
    final gpsActive = await Geolocator.isLocationServiceEnabled();
/* 
    await Future.wait<void>([
      Permission.location.isGranted.then((value) => gpsPermission = value),
      Geolocator.isLocationServiceEnabled().then((value) => gpsActive = value)
    ]); */

    if(gpsPermission && gpsActive){
      Navigator.pushReplacement(context, navigateMapFadeIn(context, MapsPage()));
      return '';
    } else if (!gpsPermission){
      Navigator.pushReplacement(context, navigateMapFadeIn(context, GPSAccessPage()));
      return 'Enable GPS Permission';
    } else{
      return 'Enable GPS';
    }
  }
}