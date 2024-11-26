import '../database.dart';

class PerformanceTable extends SupabaseTable<PerformanceRow> {
  @override
  String get tableName => 'performance';

  @override
  PerformanceRow createRow(Map<String, dynamic> data) => PerformanceRow(data);
}

class PerformanceRow extends SupabaseDataRow {
  PerformanceRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PerformanceTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get eventId => getField<String>('event_id');
  set eventId(String? value) => setField<String>('event_id', value);

  String get metric => getField<String>('metric')!;
  set metric(String value) => setField<String>('metric', value);

  double get value => getField<double>('value')!;
  set value(double value) => setField<double>('value', value);

  DateTime get dateRecorded => getField<DateTime>('date_recorded')!;
  set dateRecorded(DateTime value) =>
      setField<DateTime>('date_recorded', value);
}
