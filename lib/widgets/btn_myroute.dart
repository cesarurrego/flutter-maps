part of 'widgets.dart';

class BtnMyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, _) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 25,
            child: IconButton(
              icon: Icon(
                mapBloc.state.drawRoute ? Icons.more_horiz : Icons.point_of_sale,
                color: Colors.black87,
              ),
              onPressed: () {
                mapBloc.add(OnDrawRoute());
              },
            ),
          ));
      },
    );
  }
}
