import '../database.dart';

class RepliesTable extends SupabaseTable<RepliesRow> {
  @override
  String get tableName => 'replies';

  @override
  RepliesRow createRow(Map<String, dynamic> data) => RepliesRow(data);
}

class RepliesRow extends SupabaseDataRow {
  RepliesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RepliesTable();

  String get announcementId => getField<String>('announcement_id')!;
  set announcementId(String value) =>
      setField<String>('announcement_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);
}
