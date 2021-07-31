part of 'helpers.dart';

Future<BitmapDescriptor> getInitialMarkerIcon(int minutes) async {
  return await _getMarkerPainter(InitialMakerPainter(minutes));
}
 
Future<BitmapDescriptor> getDestinationMarkerIcon(
    String destino, double minutos) async {
  return await _getMarkerPainter(DestinationMakerPainter(destino, minutos));
}

// Funcion generica para convertir un CustomPainter a BitmapDescriptor
Future<BitmapDescriptor> _getMarkerPainter(
  CustomPainter markerPainter,
  {double width = 350, double height = 150}
) async {
  final recorder = new ui.PictureRecorder();
  final canvas = new ui.Canvas(recorder);
 
  markerPainter.paint(canvas, ui.Size(width, height));
 
  final picture = recorder.endRecording();
 
  final image = await picture.toImage(width.toInt(), height.toInt());
 
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
 
  return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
}