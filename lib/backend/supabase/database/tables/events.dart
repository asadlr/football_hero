import '../database.dart';

class EventsTable extends SupabaseTable<EventsRow> {
  @override
  String get tableName => 'events';

  @override
  EventsRow createRow(Map<String, dynamic> data) => EventsRow(data);
}

class EventsRow extends SupabaseDataRow {
  EventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EventsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  PostgresTime? get startDate => getField<PostgresTime>('start_date');
  set startDate(PostgresTime? value) =>
      setField<PostgresTime>('start_date', value);

  PostgresTime? get endDate => getField<PostgresTime>('end_date');
  set endDate(PostgresTime? value) => setField<PostgresTime>('end_date', value);

  String? get location => getField<String>('location ');
  set location(String? value) => setField<String>('location ', value);

  String? get eventType => getField<String>('event_type');
  set eventType(String? value) => setField<String>('event_type', value);

  String? get teamId => getField<String>('team_id');
  set teamId(String? value) => setField<String>('team_id', value);

  String? get communityId => getField<String>('community_id');
  set communityId(String? value) => setField<String>('community_id', value);
}
