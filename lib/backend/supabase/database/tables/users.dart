import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  DateTime get dob => getField<DateTime>('dob')!;
  set dob(DateTime value) => setField<DateTime>('dob', value);

  String get role => getField<String>('role')!;
  set role(String value) => setField<String>('role', value);

  String? get profilePicture => getField<String>('profile_picture');
  set profilePicture(String? value) =>
      setField<String>('profile_picture', value);

  String? get parentEmail => getField<String>('parent_email');
  set parentEmail(String? value) => setField<String>('parent_email', value);

  int? get age => getField<int>('age');
  set age(int? value) => setField<int>('age', value);
}
