import '../database.dart';

class AnnouncementsTable extends SupabaseTable<AnnouncementsRow> {
  @override
  String get tableName => 'announcements';

  @override
  AnnouncementsRow createRow(Map<String, dynamic> data) =>
      AnnouncementsRow(data);
}

class AnnouncementsRow extends SupabaseDataRow {
  AnnouncementsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AnnouncementsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get teamId => getField<String>('team_id')!;
  set teamId(String value) => setField<String>('team_id', value);

  String get creatorId => getField<String>('creator_id')!;
  set creatorId(String value) => setField<String>('creator_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get fileUrl => getField<String>('file_url');
  set fileUrl(String? value) => setField<String>('file_url', value);

  String? get fileType => getField<String>('file_type');
  set fileType(String? value) => setField<String>('file_type', value);
}
