import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/blocs/moderator_page%20(prospective%20feature%20-%20not%20used)/index.dart';

class ModeratorRatingScreen extends StatefulWidget {
  const ModeratorRatingScreen({
    required ModeratorRatingBloc moderatorRatingBloc,
    Key? key,
  })  : _moderatorRatingBloc = moderatorRatingBloc,
        super(key: key);

  final ModeratorRatingBloc _moderatorRatingBloc;

  @override
  ModeratorRatingScreenState createState() {
    return ModeratorRatingScreenState();
  }
}

class ModeratorRatingScreenState extends State<ModeratorRatingScreen> {
  ModeratorRatingScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModeratorRatingBloc, ModeratorRatingState>(
        bloc: widget._moderatorRatingBloc,
        builder: (
          BuildContext context,
          ModeratorRatingState currentState,
        ) {
          if (currentState is UnModeratorRatingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorModeratorRatingState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    child: Text('reload'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
          if (currentState is InModeratorRatingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._moderatorRatingBloc.add(LoadModeratorRatingEvent());
  }
}
