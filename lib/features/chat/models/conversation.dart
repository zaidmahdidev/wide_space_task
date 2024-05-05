import 'dart:convert';

import 'base_model.dart';
import 'message.dart';

class Conversation extends BaseModel {
  final int? id;
  final Map<String, dynamic>? data;

  Message? lastMessage;

  bool get hasPreviewMessage => lastMessage != null;

  Conversation.badilni({Map<String, dynamic> data = const {}})
      : id = null,
        data = {
          'user': {'id': 1, 'name': ''},
          ...data,
        };

  Conversation({required this.data}) : id = null;

  Map? get user =>
      data != null && data!.containsKey('user') ? data!['user'] : null;

  int? get loanId =>
      data != null && data!.containsKey('loan_id') ? data!['loan_id'] : null;

  String? get phone =>
      data != null && data!.containsKey('phone') ? data!['phone'] : null;

  int? get loanApplicationId =>
      data != null && data!.containsKey('loan_application_id')
          ? data!['loan_application_id']
          : null;

  Conversation.fromMap(Map<String, dynamic> map)
      : id = int.tryParse(map['id'].toString()),
        data = map.containsKey('data')
            ? (map['data'] is Map ? map['data'] : json.decode(map['data']))
            : null,
        lastMessage = map['last_message'] != null
            ? Message.fromMap(map['last_message'])
            : null,
        super.fromMap(map);

  static List<Conversation> fromList(List<dynamic> items) =>
      items.map((item) => Conversation.fromMap(item)).toList();

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'data': data,
        'loan_id': loanId,
        'phone': phone,
        'loan_application_id': loanApplicationId,
        'last_message': lastMessage?.toMap(),
        ...super.toMap(),
      };

  @override
  int get hashCode => id.hashCode ^ data.hashCode ^ super.hashCode;

  @override
  bool operator ==(other) => identical(this, other);

  @override
  String toString() {
    return 'Conversation(id: $id, data: $data, ${super.toString()})';
  }
}
