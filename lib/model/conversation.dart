import 'dart:io';

import 'package:sqflite/sqflite.dart';

class Conversation {
  String name;
  String uuid;
  String assistantName;

  Conversation(
      {required this.name, required this.uuid, required this.assistantName});
}

class Message {
  String uuid;
  String conversationUuid;
  String text;
  DateTime createdAt;
  MessageRole role;
  Usage? usage;

  Message({
    required this.uuid,
    required this.conversationUuid,
    required this.text,
    required this.createdAt,
    required this.role,
    this.usage,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'conversation_uuid': conversationUuid,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'role': role.toString(),
      'prompt_tokens': usage?.promptTokens,
      'completion_tokens': usage?.completionTokens,
      'total_tokens': usage?.totalTokens,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      uuid: map['uuid'],
      conversationUuid: map['conversation_uuid'],
      text: map['text'],
      createdAt: DateTime.parse(map['created_at']),
      role: MessageRole.values.firstWhere((e) => e.toString() == map['role']),
      usage: map['prompt_tokens'] != null
          ? Usage(
              promptTokens: map['prompt_tokens'],
              completionTokens: map['completion_tokens'],
              totalTokens: map['total_tokens'],
            )
          : null,
    );
  }
}

enum MessageRole {
  system,
  assistant,
  user,
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });
}

class ConversationRepository {
  static const String _tableConversationName = 'conversations';
  static const String _columnUuid = 'uuid';
  static const String _columnName = 'name';
  static const String _columnAssistantName = 'assistant_name';

  static const String _tableMessageName = 'messages';
  static const String _columnMessageUuid = 'uuid';
  static const String _columnMessageConversationUuid = 'conversation_uuid';
  static const String _columnMessageText = 'text';
  static const String _columnMessageCreatedAt = 'created_at';
  static const String _columnMessageRole = 'role';
  // optional usage
  static const String _columnPromptTokens = 'prompt_tokens';
  static const String _columnCompletionTokens = 'completion_tokens';
  static const String _columnTotalTokens = 'total_tokens';

  static Database? _database;

  Future<Database> _getDb() async {
    _database ??= await openDatabase(
      'yaaa_conversation.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE $_tableConversationName (
              $_columnUuid TEXT PRIMARY KEY,
              $_columnName TEXT NOT NULL,
              $_columnAssistantName TEXT NOT NULL
            )
          ''');
        await db.execute('''
            CREATE TABLE $_tableMessageName (
              $_columnMessageUuid TEXT PRIMARY KEY,
              $_columnMessageConversationUuid TEXT NOT NULL,
              $_columnMessageText TEXT NOT NULL,
              $_columnMessageCreatedAt TEXT NOT NULL,
              $_columnMessageRole TEXT NOT NULL,
              $_columnPromptTokens INTEGER,
              $_columnCompletionTokens INTEGER,
              $_columnTotalTokens INTEGER
            )
          ''');
      },
    );

    return _database!;
  }

  Future<List<Conversation>> getAllConversations() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps =
        await db.query(_tableConversationName);

    return List.generate(maps.length, (i) {
      return Conversation(
        name: maps[i][_columnName],
        uuid: maps[i][_columnUuid],
        assistantName: maps[i][_columnAssistantName],
      );
    });
  }

  Future<void> addConversation(Conversation conversation) async {
    final db = await _getDb();
    await db.insert(
      _tableConversationName,
      {
        _columnUuid: conversation.uuid,
        _columnName: conversation.name,
        _columnAssistantName: conversation.assistantName,
      },
    );
  }

  Future<void> updateConversation(Conversation conversation) async {
    final db = await _getDb();
    await db.update(
      _tableConversationName,
      {
        _columnUuid: conversation.uuid,
        _columnName: conversation.name,
        _columnAssistantName: conversation.assistantName,
      },
      where: '$_columnUuid = ?',
      whereArgs: [conversation.uuid],
    );
  }

  Future<void> deleteConversation(String uuid) async {
    final db = await _getDb();
    await db.transaction((txn) async {
      await txn.delete(
        _tableConversationName,
        where: '$_columnUuid = ?',
        whereArgs: [uuid],
      );
      await txn.delete(
        _tableMessageName,
        where: '$_columnMessageConversationUuid = ?',
        whereArgs: [uuid],
      );
    });
  }

  Future<List<Message>> getMessages(String conversationUuid) async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableMessageName,
      where: '$_columnMessageConversationUuid = ?',
      whereArgs: [conversationUuid],
    );

    // print((" - debug get message ", maps));

    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
  }

  Future<void> addMessage(Message message) async {
    final db = await _getDb();
    await db.insert(
      _tableMessageName,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteMessage(String uuid) async {
    final db = await _getDb();
    await db.delete(
      _tableMessageName,
      where: '$_columnMessageUuid = ?',
      whereArgs: [uuid],
    );
  }

  Future<void> deleteConversationMessages(String conversationUuid) async {
    final db = await _getDb();
    await db.delete(
      _tableMessageName,
      where: '$_columnMessageConversationUuid = ?',
      whereArgs: [conversationUuid],
    );
  }

  // debug print all messsages in db
  Future<void> printAllMessages() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query(_tableMessageName);

    print((" - debug print all messages ", maps));

    // delete all messages
    // await db.delete(_tableMessageName);
  }

  // debug show all databases
  Future<void> showAllDatabases() async {
    final databasesPath = await getDatabasesPath();
    print((" - debug show all databases ", databasesPath));

    // list files in databasesPath
    final files = Directory(databasesPath).listSync();
    for (var file in files) {
      print((" - debug show all databases ", file));
    }
  }
}
