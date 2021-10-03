import 'package:first_offline_app/src/models/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class HomePageBody extends StatelessWidget {
  final List<Pokemon> pokemonList;
  final String state;

  const HomePageBody({Key? key, required this.pokemonList, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pokemonList.length == 0) {
      return Center(child: Text('No pokemons'));
    }
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          Align(
            child: Text('The state is: $state'),
          ),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              return ListTile(
                title: Text(pokemon.name),
                tileColor: RandomColor().randomColor(colorHue: ColorHue.blue),
                onTap: () {
                  print(pokemon.name);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
