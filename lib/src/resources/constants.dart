const String POKEMON_API_URL = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200";

const String DATABASE_NAME = "offline_first.db";
const String POKEMON_TABLE_NAME = "pokemon";

const String CREATE_POKEMON_TABLE = '''
    create table $POKEMON_TABLE_NAME (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      url TEXT
    )
''';
