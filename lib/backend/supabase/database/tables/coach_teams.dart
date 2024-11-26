import '../database.dart';

class CoachTeamsTable extends SupabaseTable<CoachTeamsRow> {
  @override
  String get tableName => 'coach_teams';

  @override
  CoachTeamsRow createRow(Map<String, dynamic> data) => CoachTeamsRow(data);
}

class CoachTeamsRow extends SupabaseDataRow {
  CoachTeamsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CoachTeamsTable();

  String get coachId => getField<String>('coach_id')!;
  set coachId(String value) => setField<String>('coach_id', value);

  String? get teamId => getField<String>('team_id');
  set teamId(String? value) => setField<String>('team_id', value);
}
