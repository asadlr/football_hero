import '../database.dart';

class MediaTable extends SupabaseTable<MediaRow> {
  @override
  String get tableName => 'media';

  @override
  MediaRow createRow(Map<String, dynamic> data) => MediaRow(data);
}

class MediaRow extends SupabaseDataRow {
  MediaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MediaTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get fileUrl => getField<String>('file_url');
  set fileUrl(String? value) => setField<String>('file_url', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
