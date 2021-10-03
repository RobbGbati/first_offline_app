import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:first_offline_app/src/controllers/local_repositories/local_pokemon_repository.dart';
import 'package:first_offline_app/src/controllers/remote_repositories/remote_pokemon_repository.dart';
import 'package:first_offline_app/src/models/pokemon.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'pokemon_state.dart';

class PokemonCubit extends Cubit<PokemonState> {
  final RemotePokemonRepository remotePokemonRepository;
  final LocalPokemonRepository localPokemonRepository;
  final Connectivity connectivity;
  var log = Logger();

  PokemonCubit({
    required this.remotePokemonRepository,
    required this.localPokemonRepository,
    required this.connectivity
  }) : super(PokemonInitial());

  Future<void> getPokemonList() async {
    log.i('get pokemon list');
    final connectivityStatus = await connectivity.checkConnectivity();
    if (connectivityStatus == ConnectivityResult.none) {
      getLocalPokemonList();
      log.i('get local pokemon list');
    } else {
      getRemotePokemonList();
      log.i('get remote pokemon list');
    }
  }

  // get remote data
  Future<void> getRemotePokemonList() async {
    log.i('get remote pokemon list');
    try {
      emit(PokemonLoading());
      final result =  await remotePokemonRepository.getAllPokemeons();
      emit(RemotePokemonLoaded(pokemonList: result));
    } catch ( error) {
      emit(PokemonError());
      log.e('Error fetching remote pokemon list');
    }
  }

  Future<void> getLocalPokemonList() async {
    log.i('get local pokemon list');
    try {
      emit(PokemonLoading());
      // delay to fake http request fetch time
      await Future.delayed(Duration(microseconds: 500));
      final result = await localPokemonRepository.getAllPokemons();
      emit(LocalPokemonLoaded(pokemonList: result));
    } catch (err) {
      emit(PokemonError());
      log.e('Error fetching remote pokemon list');
    }
  }

  Future<void> updateLocalPokemonDatabase(List<Pokemon> pokemonList) async {
    log.i('update pokemon list in database');
    try {
      await localPokemonRepository.updateLocalPokemonDatatable(pokemonList);
      emit(LocalPokemonSync());
    } catch (error) {
      emit(PokemonError());
      log.e('Error fetching remote pokemon list');
    }
  }
}
