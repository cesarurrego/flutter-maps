part of 'helpers.dart';

void calculateAlert( BuildContext context ){
   if(Platform.isAndroid) {
    showDialog(
      context: context,
      builder: ( context ) => AlertDialog(
        title: Text('Wait please!'),
        content: Text('Calculating Route. Wait!'),
      )
    );
  } else {
    showCupertinoDialog(
      context: context, 
      builder: ( _ ) => CupertinoAlertDialog(
        title: Text('Wait please!'),
        content: Text('Calculating Route. Wait please!'),
      )
    );
  }
}