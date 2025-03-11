import 'package:flutter/material.dart';
import 'package:radio_app/blocs/moderator_rating/index.dart';

class ModeratorRatingPage extends StatefulWidget {
  static const String routeName = '/moderatorRating';

  @override
  _ModeratorRatingPageState createState() => _ModeratorRatingPageState();
}

class _ModeratorRatingPageState extends State<ModeratorRatingPage> {
  final _moderatorRatingBloc = ModeratorRatingBloc(UnModeratorRatingState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ModeratorRating'),
      ),
      body: ModeratorRatingScreen(moderatorRatingBloc: _moderatorRatingBloc),
    );
  }
}
