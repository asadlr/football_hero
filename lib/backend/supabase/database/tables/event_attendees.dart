import '../database.dart';

class EventAttendeesTable extends SupabaseTable<EventAttendeesRow> {
  @override
  String get tableName => 'event_attendees';

  @override
  EventAttendeesRow createRow(Map<String, dynamic> data) =>
      EventAttendeesRow(data);
}

class EventAttendeesRow extends SupabaseDataRow {
  EventAttendeesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EventAttendeesTable();

  String get eventId => getField<String>('event_id')!;
  set eventId(String value) => setField<String>('event_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get attendanceStatus => getField<String>('attendance_status');
  set attendanceStatus(String? value) =>
      setField<String>('attendance_status', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);
}
