import 'package:first_offline_app/src/models/pokemon.dart';
import 'package:first_offline_app/src/resources/constants.dart';
import 'package:first_offline_app/src/resources/utils.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class LocalPokemonRepository {
  var databaseFuture = Utils.dbHelper.database;
  var log = Logger();

  Future<List<Pokemon>> getAllPokemons() async {
    log.i('get pokemon list in database');
    late final List<Pokemon> pokemonList;
    final Database db = await databaseFuture;
    final pokemonMap = await db.query(POKEMON_TABLE_NAME);
    pokemonList = pokemonMap.map((p) => Pokemon.fromJson(p)).toList();
    return pokemonList;
  }

  Future<void> updateLocalPokemonDatatable(List<Pokemon> pokemonList) async {
    log.i('update pokemon list in database');
    final Database db = await databaseFuture;
    Batch batch = db.batch();
    pokemonList.forEach((element) async {
      batch.insert(
        POKEMON_TABLE_NAME,
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    });
    batch.commit();
  }
}
