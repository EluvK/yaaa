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

  Message({
    required this.uuid,
    required this.conversationUuid,
    required this.text,
    required this.createdAt,
    required this.role,
  });
}

enum MessageRole {
  system,
  assistant,
  user,
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
              $_columnMessageRole TEXT NOT NULL
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

    print((" - debug get message ", maps));

    return List.generate(maps.length, (i) {
      return Message(
        uuid: maps[i][_columnMessageUuid],
        conversationUuid: maps[i][_columnMessageConversationUuid],
        text: maps[i][_columnMessageText],
        createdAt: DateTime.parse(maps[i][_columnMessageCreatedAt]),
        role: MessageRole.values.firstWhere(
          (role) => role.toString() == maps[i][_columnMessageRole],
        ),
      );
    });
  }

  Future<void> addMessage(Message message) async {
    final db = await _getDb();
    await db.insert(
      _tableMessageName,
      {
        _columnMessageUuid: message.uuid,
        _columnMessageConversationUuid: message.conversationUuid,
        _columnMessageText: message.text,
        _columnMessageCreatedAt: message.createdAt.toIso8601String(),
        _columnMessageRole: message.role.toString(),
      },
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
