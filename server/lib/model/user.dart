import '../server.dart';

class User extends ManagedObject<Kzoo_User> implements Kzoo_User {}

class Kzoo_User {
  @primaryKey
  int id;

  @Column(nullable: false)
  String email;

  @Column(nullable: false)
  String user_password;
}