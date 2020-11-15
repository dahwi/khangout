import 'package:aqueduct/aqueduct.dart';
import '../model/kzooUser.dart';
import '../server.dart';

class KzooUserController extends ResourceController {
  KzooUserController(this.context);

  final ManagedContext context;

  // GET
  // get a list of users
  @Operation.get()
  Future<Response> getAllKzooUsers() async {
    final kzooUserQuery = Query<KzooUser>(context);
    final kzooUsers = await kzooUserQuery.fetch();

    return Response.ok(kzooUsers);
  }

  // get a single kzoo user by its email
  @Operation.get('email')
  // declare input parameter which is path('email') and bind it as argument of type string
  Future<Response> getKzooUserByEmail(@Bind.path('email') String email) async {
    final kzooUserQuery = Query<KzooUser>(context)
      ..where((h) => h.email).equalTo(email);
    final kzooUser = await kzooUserQuery.fetchOne();
    if (kzooUser == null) {
      return Response.notFound();
    }
    return Response.ok(kzooUser);
  }

  // POST; Insert new kzoo user info into the database
  // The request will contain the JSON representation of a kzoo user in its body
  @Operation.post()
  Future<Response> createKzooUser(@Bind.body() KzooUser inputKzooUser) async {
    final query = Query<KzooUser>(context)..values = inputKzooUser;
    final insertedKzooUser = await query.insert();
    return Response.ok(insertedKzooUser);
  }

  //PUT
  @Operation.put('email')
  Future<Response> updateKzooUserByEmail(@Bind.path('email') String email, @Bind.body() KzooUser inputKzooUser) async {
    final kzooUserQuery = Query<KzooUser>(context)
      ..where((h) => h.email).equalTo(email)
      ..values = inputKzooUser;
    final kzooUser = await kzooUserQuery.updateOne();
    if (kzooUser == null) {
      return Response.notFound();
    }
    return Response.ok(kzooUser);
  }

  // DELETE
  @Operation.delete('email')
  Future<Response> deleteKzooUserByEmail(@Bind.path('email') String email) async {
    final kzooUserQuery = Query<KzooUser>(context)
      ..where((h) => h.email).equalTo(email);
    final kzooUser = await kzooUserQuery.delete();
    if (kzooUser == null) {
      return Response.notFound();
    }
    return Response.ok(kzooUser);
  }
}