import 'package:connectivity/connectivity.dart';
import 'package:first_offline_app/src/controllers/local_repositories/local_pokemon_repository.dart';
import 'package:first_offline_app/src/controllers/remote_repositories/remote_pokemon_repository.dart';
import 'package:first_offline_app/src/cubits/pokemon_cubit.dart';
import 'package:first_offline_app/src/resources/no_internet_mixin.dart';
import 'package:first_offline_app/src/views/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with NoInternetMixin {
  late final PokemonCubit pokemonCubit;
  late final _remotePokemonRepository;
  late final _localPokemonRepository;
  late final _connectivity;

  @override
  void initState() {
    _remotePokemonRepository = RemotePokemonRepository();
    _localPokemonRepository = LocalPokemonRepository();
    _connectivity = Connectivity();

    pokemonCubit = PokemonCubit(
      remotePokemonRepository: _remotePokemonRepository, 
      localPokemonRepository: _localPokemonRepository, 
      connectivity: _connectivity);

    pokemonCubit.getPokemonList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline first app'),
        ),
        body: BlocConsumer<PokemonCubit, PokemonState>(
          bloc: pokemonCubit,
          listener: (context, state) {
            if (state is RemotePokemonLoaded) {
              _localPokemonRepository.updateLocalPokemonDatatable(
                state.pokemonList
              );
            }
          },
          builder: (context, state) {
            if (state is PokemonLoading) {
              return Center(child: CircularProgressIndicator(),);
            }
            if (state is RemotePokemonLoaded) {
              return HomePageBody(pokemonList: state.pokemonList, state: 'RemotePokemonLoaded',);
            }
            if (state is LocalPokemonLoaded) {
              return HomePageBody(pokemonList: state.pokemonList, state: 'LocalPokemonLoaded');
            }
            if (state is PokemonError) {
              return Center(child: Text('Error.'),);
            }

            return SizedBox();
          }
      ),
    );
  }
}
