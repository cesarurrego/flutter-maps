import 'package:flutter/material.dart'
;
import 'package:maps_app/custom_markers/custom_markers.dart';

class TestMarkerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 370,
          height: 170,
          color: Colors.red,
          child: CustomPaint(
            // painter: InitialMakerPainter(15),
            painter: DestinationMakerPainter(
              'Specify the maximum number of results to return. The default is 5 and the maximum supported is 10.', 
              25123
            ),
          ),
        )
     ),
   );
  }
}