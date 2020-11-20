import '../server.dart';

class UserHangouts extends ManagedObject<users_hangouts>
    implements users_hangouts {}

class users_hangouts {
  @primaryKey
  int id;

  @Column(nullable: false, databaseType: ManagedPropertyType.bigInteger)
  int user_id;

  @Column(nullable: false, databaseType: ManagedPropertyType.bigInteger)
  int hangout_id;
}
