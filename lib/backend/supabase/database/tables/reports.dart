import '../database.dart';

class ReportsTable extends SupabaseTable<ReportsRow> {
  @override
  String get tableName => 'reports';

  @override
  ReportsRow createRow(Map<String, dynamic> data) => ReportsRow(data);
}

class ReportsRow extends SupabaseDataRow {
  ReportsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReportsTable();

  String get reportId => getField<String>('report_id')!;
  set reportId(String value) => setField<String>('report_id', value);

  String get replyId => getField<String>('reply_id')!;
  set replyId(String value) => setField<String>('reply_id', value);

  String get reportedByUserId => getField<String>('reported_by_user_id')!;
  set reportedByUserId(String value) =>
      setField<String>('reported_by_user_id', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);
}
