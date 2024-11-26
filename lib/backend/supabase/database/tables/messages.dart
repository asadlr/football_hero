import '../database.dart';

class MessagesTable extends SupabaseTable<MessagesRow> {
  @override
  String get tableName => 'messages';

  @override
  MessagesRow createRow(Map<String, dynamic> data) => MessagesRow(data);
}

class MessagesRow extends SupabaseDataRow {
  MessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MessagesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get senderId => getField<String>('sender_id')!;
  set senderId(String value) => setField<String>('sender_id', value);

  String get recipientId => getField<String>('recipient_id')!;
  set recipientId(String value) => setField<String>('recipient_id', value);

  String get content => getField<String>('content')!;
  set content(String value) => setField<String>('content', value);

  DateTime get sentAt => getField<DateTime>('sent_at')!;
  set sentAt(DateTime value) => setField<DateTime>('sent_at', value);
}
