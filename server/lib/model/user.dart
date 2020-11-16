import '../server.dart';

class User extends ManagedObject<kzoo_user> implements kzoo_user {}

class kzoo_user {
  @primaryKey
  int id;

  @Column(nullable: false)
  String email;

  @Column(nullable: false)
  String user_password;
}
