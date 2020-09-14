import 'package:client/api/game_api.dart';
import 'package:client/api/models/game.dart';
import 'package:client/shared/sidenav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameRoute extends StatelessWidget {
  static const routeName = '/games';
  static const icon = Icons.tv;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidenav(),
      appBar: AppBar(title: Text('Games')),
      body: GameList(),
    );
  }
}

class GameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameApi api = context.repository();
    return FutureBuilder(
      future: api.listGames(),
      builder: (context, AsyncSnapshot<List<GameModel>> state) {
        if (state.hasData) {
          return ListView(
            children: state.data
                .map((app) => Container(
                  // constraints: BoxConstraints.expand(),
                  child: Stack(
                        children: [Image.network(api.getBannerUrl(app.slug))],
                      ),
                ))
                .toList(),
          );
        }
        return Container();
      },
    );
  }
}
