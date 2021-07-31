part of 'custom_markers.dart';

class InitialMakerPainter extends CustomPainter {

  final int minutes;

  InitialMakerPainter(this.minutes);

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
    path.moveTo( 40, 20 );
    path.lineTo( size.width-10, 20 );
    path.lineTo( size.width-10, 100 );
    path.lineTo( 40, 100 );

    canvas.drawShadow(
      path,
      Colors.black87,
      10,
      false
    );

    // Caja
    final whiteBox = Rect.fromLTWH(40, 20, size.width-55, 80);
    canvas.drawRect(whiteBox, paint);

      // Caja
    paint.color = Colors.black;
    final blackBox = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(blackBox, paint);

    //Textos
    TextSpan textSpan = new TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
      text: minutes.toString()
    );

    TextPainter textPainter = new TextPainter( 
      text: textSpan, 
      textDirection: TextDirection.ltr, 
      textAlign: TextAlign.center
    )..layout(
      minWidth: 70,
      maxWidth: 70 
    );

    textPainter.paint(canvas, Offset(40,32));

    //Minutes
    textSpan = new TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      text: 'Min'
    );

    textPainter = new TextPainter( 
      text: textSpan, 
      textDirection: TextDirection.ltr, 
      textAlign: TextAlign.center
    )..layout(
      minWidth: 70,
      maxWidth: 70 
    );

    textPainter.paint(canvas, Offset(40, 62));

    //Ubicacion
    textSpan = new TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
      text: 'My location'
    );

    textPainter = new TextPainter( 
      text: textSpan, 
      textDirection: TextDirection.ltr, 
      textAlign: TextAlign.center
    )..layout(
      maxWidth: size.width-130
    );

    textPainter.paint(canvas, Offset(140, 45));
  }

  @override
  bool shouldRepaint(InitialMakerPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(InitialMakerPainter oldDelegate) => false;
}