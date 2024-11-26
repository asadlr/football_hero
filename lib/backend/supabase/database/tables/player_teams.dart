import '../database.dart';

class PlayerTeamsTable extends SupabaseTable<PlayerTeamsRow> {
  @override
  String get tableName => 'player_teams';

  @override
  PlayerTeamsRow createRow(Map<String, dynamic> data) => PlayerTeamsRow(data);
}

class PlayerTeamsRow extends SupabaseDataRow {
  PlayerTeamsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlayerTeamsTable();

  String get playerId => getField<String>('player_id')!;
  set playerId(String value) => setField<String>('player_id', value);

  String? get teamId => getField<String>('team_id');
  set teamId(String? value) => setField<String>('team_id', value);

  DateTime? get joinedAt => getField<DateTime>('joined_at');
  set joinedAt(DateTime? value) => setField<DateTime>('joined_at', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);
}
