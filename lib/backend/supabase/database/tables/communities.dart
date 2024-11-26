import '../database.dart';

class CommunitiesTable extends SupabaseTable<CommunitiesRow> {
  @override
  String get tableName => 'communities';

  @override
  CommunitiesRow createRow(Map<String, dynamic> data) => CommunitiesRow(data);
}

class CommunitiesRow extends SupabaseDataRow {
  CommunitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunitiesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String get adresss => getField<String>('adresss')!;
  set adresss(String value) => setField<String>('adresss', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);

  String? get socialMedia => getField<String>('social_media');
  set socialMedia(String? value) => setField<String>('social_media', value);

  String? get manager => getField<String>('manager');
  set manager(String? value) => setField<String>('manager', value);
}
