import 'package:dio/dio.dart';
import 'package:first_offline_app/src/models/pokemon.dart';
import 'package:first_offline_app/src/resources/constants.dart';
import 'package:first_offline_app/src/resources/utils.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class RemotePokemonRepository {
  final dio = Dio();
  var databaseFuture = Utils.dbHelper.database;
  var log = Logger();

  Future<List<Pokemon>> getAllPokemeons() async {
    log.i(this);
    late final List<Pokemon> pokemonList;
    final Database db = await databaseFuture;
    try {
      // try to fetch data from API
      Response response = await dio.get(POKEMON_API_URL);
      if (response.statusCode == 200) {
        final pokemons = (response.data['results'] as List);
        pokemonList = pokemons.map((p) => Pokemon.fromJson(p)).toList();
      }
    } on DioError catch (_) {
      // return data from local DB in case of DioError
      final pokemonMap = await db.query(POKEMON_TABLE_NAME);
      pokemonList = pokemonMap.map((p) => Pokemon.fromJson(p)).toList();
    }
    return pokemonList;
  }
}
