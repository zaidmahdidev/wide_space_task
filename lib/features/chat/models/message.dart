import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import 'base_model.dart';

enum MessageType { text, image, audio, video }

class Message extends BaseModel {
  final dynamic id;
  final dynamic body;
  final MessageType? type;
  final int? participationId;
  final int? conversationId;
  final bool? isSender;
  Map<String, dynamic>? data;
  bool? isSeen;

  // TransactionModel? referencedTransaction;

  bool get isNotSeen => isSeen != null && !isSeen!;

  // Message.text(String text, {this.conversationId, this.referencedTransaction})
  Message.text(String text, {this.conversationId})
      : id = const Uuid().v4(),
        participationId = null,
        type = MessageType.text,
        body = text,
        data = {
          // if (referencedTransaction != null) ...{
          //   'referenced_transaction_id': referencedTransaction.id
          // }
        },
        isSender = true,
        isSeen = true,
        super(createdAt: DateTime.now(), updatedAt: DateTime.now());

  Message.audio(File file, {required this.conversationId})
      : id = const Uuid().v4(),
        participationId = null,
        type = MessageType.audio,
        body = file,
        data = {},
        isSender = true,
        isSeen = true,
        super(createdAt: DateTime.now(), updatedAt: DateTime.now());

  Message.image(File file, {required this.conversationId})
      : id = const Uuid().v4(),
        participationId = null,
        type = MessageType.image,
        body = file,
        data = {},
        isSender = true,
        isSeen = true,
        super(createdAt: DateTime.now(), updatedAt: DateTime.now());

  Message.video(File file, {required this.conversationId})
      : id = const Uuid().v4(),
        participationId = null,
        type = MessageType.video,
        body = file,
        data = {},
        isSender = true,
        isSeen = true,
        super(createdAt: DateTime.now(), updatedAt: DateTime.now());

  Message.fromMap(Map<String, dynamic> map)
      : id = const Uuid().v4(),
        conversationId = map['conversation_id'],
        participationId = map['participation_id'],
        isSender = map['is_sender'],
        isSeen = map['is_seen'],
        type = MessageType.values
            .firstWhereOrNull((type) => type.name == map['type']),
        body = map['body'],
        // referencedTransaction = map['referenced_transaction'] != null
        //     ? TransactionModel.fromJson(map['referenced_transaction'])
        //     : null,
        data = map['data'] != null && map['data'] is Map ? map['data'] : {},
        super.fromMap(map);

  static List<Message> fromList(List<dynamic> items) =>
      items.map((item) => Message.fromMap(item)).toList();

  @override
  Map<String, dynamic> toMap() => {
        'conversation_id': conversationId,
        'participation_id': participationId,
        'body': body,
        'type': type!.name,
        'data': data,
        'is_seen': isSeen,
        'is_sender': isSender,
        // 'referenced_transaction_id': referencedTransaction?.id,
        ...super.toMap(),
      };

  FormData toFormData() => FormData.fromMap({
        ...toMap(),
        'body': body is File ? MultipartFile.fromFileSync(body!.path) : body,
      });

  @override
  int get hashCode => id.hashCode ^ body.hashCode ^ super.hashCode;

  @override
  bool operator ==(other) => identical(this, other);

  @override
  String toString() {
    return 'Message(id: $id, isSeen: $isSeen, isSender: $isSender, body: $body, ${super.toString()})';
  }
}
