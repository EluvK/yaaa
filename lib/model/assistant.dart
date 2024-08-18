import 'package:sqflite/sqflite.dart';

class Assistant {
  String name;
  String uuid;
  AssistantType type;
  String description;
  String prompt;

  // String? iconUrl;

  Assistant({
    required this.name,
    required this.uuid,
    required this.type,
    required this.description,
    required this.prompt,
    // this.iconUrl,
  });
}

enum AssistantType {
  system,
  userdefined,
}

// impl a to string method for the assistant type and from string method

extension AssistantTypeExtension on AssistantType {
  String get toStr {
    switch (this) {
      case AssistantType.system:
        return 'system';
      case AssistantType.userdefined:
        return 'user';
    }
  }

  static AssistantType fromStr(String str) {
    switch (str) {
      case 'system':
        return AssistantType.system;
      case 'user':
        return AssistantType.userdefined;
      default:
        return AssistantType.userdefined;
    }
  }
}

// system assistant lists
final List<Assistant> systemAssistants = [
  Assistant(
    name: 'Bot 1',
    uuid: '0170fd5d-2b08-4837-a88a-775df27d86b3',
    type: AssistantType.system,
    description: 'first system assistant',
    prompt: 'hello, i am bot 1',
  ),
];

class AssistantRepository {
  static const String _tableName = 'assistants';
  static const String _columnUuid = 'uuid';
  static const String _columnType = 'type';
  static const String _columnName = 'name';
  static const String _columnDescription = 'description';
  static const String _columnPrompt = 'prompt';

  static Database? _database;

  Future<Database> _getDb() async {
    // print('open database');

    _database ??= await openDatabase(
      'yaaa_assistant.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE $_tableName (
              $_columnUuid TEXT PRIMARY KEY,
              $_columnType TEXT NOT NULL,
              $_columnName TEXT NOT NULL,
              $_columnDescription TEXT NOT NULL,
              $_columnPrompt TEXT NOT NULL
            )
          ''');
      },
      // check and make sure the system assistants are in the database
      onOpen: (Database db) async {
        final List<Map<String, dynamic>> maps = await db.query(_tableName);
        final List uuids = maps.map((e) => e[_columnUuid]).toList();

        for (var i = 0; i < systemAssistants.length; i++) {
          if (!uuids.contains(systemAssistants[i].uuid)) {
            await db.insert(
              _tableName,
              {
                _columnUuid: systemAssistants[i].uuid,
                _columnType: systemAssistants[i].type.toStr,
                _columnName: systemAssistants[i].name,
                _columnDescription: systemAssistants[i].description,
                _columnPrompt: systemAssistants[i].prompt,
              },
            );
          }
        }
      },
    );

    return _database!;
  }

  Future<List<Assistant>> getAllAssistants() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Assistant(
        name: maps[i][_columnName],
        uuid: maps[i][_columnUuid],
        type: AssistantTypeExtension.fromStr(maps[i][_columnType]),
        description: maps[i][_columnDescription],
        prompt: maps[i][_columnPrompt],
      );
    });
  }

  Future<void> insert(Assistant assistant) async {
    final db = await _getDb();
    await db.insert(
      _tableName,
      {
        _columnUuid: assistant.uuid,
        _columnName: assistant.name,
        _columnType: assistant.type.toStr,
        _columnDescription: assistant.description,
        _columnPrompt: assistant.prompt,
      },
    );
  }

  Future<void> update(Assistant assistant) async {
    final db = await _getDb();
    await db.update(
      _tableName,
      {
        _columnUuid: assistant.uuid,
        _columnName: assistant.name,
        _columnType: assistant.type.toStr,
        _columnDescription: assistant.description,
        _columnPrompt: assistant.prompt,
      },
      where: '$_columnUuid = ?',
      whereArgs: [assistant.uuid],
    );
  }

  Future<void> delete(String uuid) async {
    final db = await _getDb();
    await db.delete(
      _tableName,
      where: '$_columnUuid = ?',
      whereArgs: [uuid],
    );
  }

  // debug print all assistants
  void printAllAssistants() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    print('All assistants:');
    for (var i = 0; i < maps.length; i++) {
      print('Assistant ${i + 1}:');
      print('  uuid: ${maps[i][_columnUuid]}');
      print('  name: ${maps[i][_columnName]}');
      print('  type: ${maps[i][_columnType]}');
      print('  description: ${maps[i][_columnDescription]}');
      print('  prompt: ${maps[i][_columnPrompt]}');
    }
  }
}