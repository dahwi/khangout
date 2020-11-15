import '../server.dart';

class KzooUser extends ManagedObject<_KzooUser> implements _KzooUser {}

class _KzooUser {
  @Column(nullable: false, indexed: true)
  String email;

  @Column(nullable: false, indexed: true)
  String user_password;

  @Column()
  List<int> hangouts;

  @Column(nullable: false, indexed: true)
  String creater;

  @Column()
  List<String> participants;
}