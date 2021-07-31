import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class GPSAccessPage extends StatefulWidget {

  @override
  _GPSAccessPageState createState() => _GPSAccessPageState();
}

class _GPSAccessPageState extends State<GPSAccessPage> with WidgetsBindingObserver{

  bool popUpStatus = false;

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
    if(state == AppLifecycleState.resumed && !popUpStatus){
      if(await Permission.location.isGranted){
        Navigator.pushReplacementNamed(context, 'loading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You must enable GPS Location to use the app'),
            MaterialButton(
              child: Text('Give Access',style: TextStyle(color: Colors.white),),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () async {
                popUpStatus = true;
                final status = await Permission.locationAlways.request();
                await this.gpsAccess(status);
                popUpStatus = false;
              }
            )
          ],
        )
     ),
   );
  }

  Future gpsAccess(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        await Navigator.pushReplacementNamed(context, 'loading');
        break;
      case PermissionStatus.limited:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}