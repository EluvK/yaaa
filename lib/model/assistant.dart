import 'package:sqflite/sqflite.dart';
import 'package:yaaa/model/llm.dart';
import 'package:yaaa/utils/predefined.dart';

class Assistant {
  String name;
  String uuid;
  AssistantType type;
  String description;
  String prompt;

  String? avatarUrl;
  DefinedModel definedModel;

  Assistant({
    required this.name,
    required this.uuid,
    required this.type,
    required this.description,
    required this.prompt,
    this.avatarUrl,
    required this.definedModel,
  });

  Map<String, dynamic> toMap() {
    return {
      AssistantRepository._columnName: name,
      AssistantRepository._columnUuid: uuid,
      AssistantRepository._columnType: type.toStr,
      AssistantRepository._columnDescription: description,
      AssistantRepository._columnPrompt: prompt,
      AssistantRepository._columnAvatarUrl: avatarUrl,
      AssistantRepository._columnEnableDefinedModel:
          definedModel.enable ? 1 : 0,
      AssistantRepository._columnDefinedModelProvider:
          definedModel.provider.name,
      AssistantRepository._columnDefinedModelName: definedModel.modelName,
    };
  }

  factory Assistant.fromMap(Map<String, dynamic> map) {
    return Assistant(
      name: map[AssistantRepository._columnName],
      uuid: map[AssistantRepository._columnUuid],
      type:
          AssistantTypeExtension.fromStr(map[AssistantRepository._columnType]),
      description: map[AssistantRepository._columnDescription],
      prompt: map[AssistantRepository._columnPrompt],
      avatarUrl: map[AssistantRepository._columnAvatarUrl],
      definedModel: DefinedModel(
        enable: map[AssistantRepository._columnEnableDefinedModel] == 1,
        provider: LLMProviderEnum.values.firstWhere((e) =>
            e.name == map[AssistantRepository._columnDefinedModelProvider]),
        modelName: map[AssistantRepository._columnDefinedModelName],
      ),
    );
  }
}

enum AssistantType {
  system,
  userDefined,
}

class DefinedModel {
  bool enable;
  LLMProviderEnum provider;
  String modelName;

  DefinedModel({
    this.enable = true,
    required this.provider,
    required this.modelName,
  });

  static DefinedModel defaultDisable() {
    return DefinedModel(
      enable: false,
      provider: LLMProviderEnum.OpenAI,
      modelName: 'gpt-4o-mini',
    );
  }
}

// impl a to string method for the assistant type and from string method

extension AssistantTypeExtension on AssistantType {
  String get toStr {
    switch (this) {
      case AssistantType.system:
        return 'system';
      case AssistantType.userDefined:
        return 'user';
    }
  }

  static AssistantType fromStr(String str) {
    switch (str) {
      case 'system':
        return AssistantType.system;
      case 'user':
        return AssistantType.userDefined;
      default:
        return AssistantType.userDefined;
    }
  }
}

class AssistantRepository {
  static const String _tableName = 'assistants';
  static const String _columnUuid = 'uuid';
  static const String _columnType = 'type';
  static const String _columnName = 'name';
  static const String _columnDescription = 'description';
  static const String _columnPrompt = 'prompt';
  static const String _columnAvatarUrl = 'avatarUrl';
  static const String _columnEnableDefinedModel = 'enableDefinedModel';
  static const String _columnDefinedModelProvider = 'definedModelProvider';
  static const String _columnDefinedModelName = 'definedModelName';

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
              $_columnPrompt TEXT NOT NULL,
              $_columnAvatarUrl TEXT,
              $_columnEnableDefinedModel INTEGER,
              $_columnDefinedModelProvider TEXT,
              $_columnDefinedModelName TEXT
            )
          ''');
      },
      // check and make sure the system assistants are in the database
      onOpen: (Database db) async {
        final List<Map<String, dynamic>> maps = await db.query(_tableName);
        final List uuids = maps.map((e) => e[_columnUuid]).toList();

        for (var i = 0; i < predefinedAssistant.length; i++) {
          if (!uuids.contains(predefinedAssistant[i].uuid)) {
            await db.insert(
              _tableName,
              predefinedAssistant[i].toMap(),
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
        avatarUrl: maps[i][_columnAvatarUrl],
        definedModel: DefinedModel(
          enable: maps[i][_columnEnableDefinedModel] == 1,
          provider: LLMProviderEnum.values.firstWhere(
              (e) => e.name == maps[i][_columnDefinedModelProvider]),
          modelName: maps[i][_columnDefinedModelName],
        ),
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
        _columnAvatarUrl: assistant.avatarUrl,
        _columnEnableDefinedModel: assistant.definedModel.enable ? 1 : 0,
        _columnDefinedModelProvider: assistant.definedModel.provider.name,
        _columnDefinedModelName: assistant.definedModel.modelName,
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
        _columnAvatarUrl: assistant.avatarUrl,
        _columnEnableDefinedModel: assistant.definedModel.enable ? 1 : 0,
        _columnDefinedModelProvider: assistant.definedModel.provider.name,
        _columnDefinedModelName: assistant.definedModel.modelName,
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
      print('  avatarUrl: ${maps[i][_columnAvatarUrl]}');
      print('  enableDefinedModel: ${maps[i][_columnEnableDefinedModel]}');
      print('  definedModelProvider: ${maps[i][_columnDefinedModelProvider]}');
      print('  definedModelName: ${maps[i][_columnDefinedModelName]}');
    }
  }
}
