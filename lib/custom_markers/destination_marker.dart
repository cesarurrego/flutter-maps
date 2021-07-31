part of 'custom_markers.dart';

class DestinationMakerPainter extends CustomPainter {

  final String description;
  final double distance;

  DestinationMakerPainter(this.description, this.distance);

  @override
  void paint(Canvas canvas, Size size) {

    final double blackCircleRad = 20;
    final double whiteCircleRad = 7;

    Paint paint = new Paint()
      ..color = Colors.black;

    //Dibujar circulo negro
    canvas.drawCircle(
      Offset( blackCircleRad, size.height-blackCircleRad ),
      blackCircleRad,
      paint
    );

    //Dibujar ciculo blanco
    paint.color = Colors.white;
    
    canvas.drawCircle(
      Offset( blackCircleRad, size.height-blackCircleRad ),
      whiteCircleRad,
      paint
    );

    // Sombra
    final path = new Path();
    path.moveTo( 0, 20 );
    path.lineTo( size.width-10, 20 );
    path.lineTo( size.width-10, 100 );
    path.lineTo( 0, 100 );

    canvas.drawShadow(
      path,
      Colors.black87,
      10,
      false
    );

    // Caja
    final whiteBox = Rect.fromLTWH(0, 20, size.width-10, 80);
    canvas.drawRect(whiteBox, paint);

    // Caja
    paint.color = Colors.black;
    final blackBox = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(blackBox, paint);

    //Textos
    double kilometers = this.distance / 1000;
    kilometers = (kilometers * 100).floorToDouble();
    kilometers = kilometers/100;

    TextSpan textSpan = new TextSpan(
      style: TextStyle(
        color: Colors.white, 
        fontSize: kilometers > 99 ? 18 : 22, 
        fontWeight: FontWeight.w400
      ),
      text: '$kilometers'
    );

    TextPainter textPainter = new TextPainter( 
      text: textSpan, 
      textDirection: TextDirection.ltr, 
      textAlign: TextAlign.center
    )..layout(
      minWidth: 70,
      maxWidth: 70 
    );

    textPainter.paint(canvas, Offset(0,32));

    //Minutes
    textSpan = new TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      text: 'Km'
    );

    textPainter = new TextPainter( 
      text: textSpan, 
      textDirection: TextDirection.ltr, 
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70 
    );

    textPainter.paint(canvas, Offset(20, 67));

    //Ubicacion
    textSpan = new TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
      text: this.description
    );

    textPainter = new TextPainter( 
      text: textSpan, 
      textDirection: TextDirection.ltr, 
      textAlign: TextAlign.left,
      maxLines: 2,
      ellipsis: '...'
    )..layout(
      maxWidth: size.width-100
    );

    textPainter.paint(canvas, Offset(87, 32));
  }
  
  @override
  bool shouldRepaint(DestinationMakerPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(DestinationMakerPainter oldDelegate) => false;

}