import 'package:sqflite/sqflite.dart';
import 'package:yaaa/utils/predefined.dart';

class Conversation {
  String name;
  String uuid;
  String assistantName;
  String assistantUuid;
  bool like;

  Conversation({
    required this.name,
    required this.uuid,
    required this.assistantName,
    required this.assistantUuid,
    this.like = false,
  });

  Map<String, dynamic> toMap() {
    return {
      ConversationRepository._columnName: name,
      ConversationRepository._columnUuid: uuid,
      ConversationRepository._columnAssistantName: assistantName,
      ConversationRepository._columnAssistantUuid: assistantUuid,
      ConversationRepository._columnLike: like ? 1 : 0,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      name: map[ConversationRepository._columnName],
      uuid: map[ConversationRepository._columnUuid],
      assistantName: map[ConversationRepository._columnAssistantName],
      assistantUuid: map[ConversationRepository._columnAssistantUuid],
      like: map[ConversationRepository._columnLike] == 1,
    );
  }
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
      ConversationRepository._columnMessageUuid: uuid,
      ConversationRepository._columnMessageConversationUuid: conversationUuid,
      ConversationRepository._columnMessageText: text,
      ConversationRepository._columnMessageCreatedAt:
          createdAt.toIso8601String(),
      ConversationRepository._columnMessageRole: role.toString(),
      ConversationRepository._columnPromptTokens: usage?.promptTokens,
      ConversationRepository._columnCompletionTokens: usage?.completionTokens,
      ConversationRepository._columnTotalTokens: usage?.totalTokens,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      uuid: map[ConversationRepository._columnMessageUuid],
      conversationUuid:
          map[ConversationRepository._columnMessageConversationUuid],
      text: map[ConversationRepository._columnMessageText],
      createdAt:
          DateTime.parse(map[ConversationRepository._columnMessageCreatedAt]),
      role: MessageRole.values.firstWhere((e) =>
          e.toString() == map[ConversationRepository._columnMessageRole]),
      usage: map[ConversationRepository._columnPromptTokens] != null
          ? Usage(
              promptTokens: map[ConversationRepository._columnPromptTokens],
              completionTokens:
                  map[ConversationRepository._columnCompletionTokens],
              totalTokens: map[ConversationRepository._columnTotalTokens],
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
  static const String _columnName = 'name';
  static const String _columnUuid = 'uuid';
  static const String _columnAssistantName = 'assistant_name';
  static const String _columnAssistantUuid = 'assistant_uuid';
  static const String _columnLike = 'like';

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
      version: 2,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE $_tableConversationName ADD COLUMN like INTEGER DEFAULT 0;
            ''');
        }
      },
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE $_tableConversationName (
              $_columnUuid TEXT PRIMARY KEY,
              $_columnName TEXT NOT NULL,
              $_columnAssistantName TEXT NOT NULL,
              $_columnAssistantUuid TEXT NOT NULL,
              $_columnLike INTEGER DEFAULT 0
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

        for (var i = 0; i < predefinedConversation.length; i++) {
          await db.insert(
            _tableConversationName,
            predefinedConversation[i].toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        for (var i = 0; i < predefinedMessage.length; i++) {
          await db.insert(
            _tableMessageName,
            predefinedMessage[i].toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      },
    );

    return _database!;
  }

  Future<List<Conversation>> getAllConversations() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps =
        await db.query(_tableConversationName);

    var result = List.generate(maps.length, (i) {
      return Conversation.fromMap(maps[i]);
    });
    result.sort((a, b) => a.like == b.like
        ? 0
        : a.like
            ? -1
            : 1);
    return result;
  }

  Future<void> addConversation(Conversation conversation) async {
    final db = await _getDb();
    await db.insert(
      _tableConversationName,
      conversation.toMap(),
    );
  }

  Future<void> updateConversation(Conversation conversation) async {
    final db = await _getDb();
    await db.update(
      _tableConversationName,
      conversation.toMap(),
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
}
