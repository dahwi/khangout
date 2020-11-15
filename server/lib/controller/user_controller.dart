import 'package:aqueduct/aqueduct.dart';
import '../model/user.dart';
import '../server.dart';

class UserController extends ResourceController {
  UserController(this.context);

  final ManagedContext context;

  // GET
  // get a list of users
  @Operation.get()
  Future<Response> getAllUsers() async {
    final userQuery = Query<User>(context);
    final users = await userQuery.fetch();

    return Response.ok(users);
  }

  // Get a single user by their email
  @Operation.get('email')
  Future<Response> getUserByEmail(@Bind.path('email') String email) async {
    final userQuery = Query<User>(context)
      ..where((h) => h.email).equalTo(email);
    final user = await userQuery.fetchOne();
    if (user == null) {
      return Response.notFound();
    }
    return Response.ok(user);
  }

  // POST; Insert new kzoo user info into the database
  // The request will contain the JSON representation of a kzoo user in its body
  @Operation.post()
  Future<Response> createUser(@Bind.body() User inputUser) async {
    final query = Query<User>(context)..values = inputUser;
    final insertedUser = await query.insert();
    return Response.ok(insertedUser);
  }

  //PUT
  @Operation.put('email')
  Future<Response> updateUserByEmail(@Bind.path('email') String email, @Bind.body() User inputUser) async {
    final userQuery = Query<User>(context)
      ..where((h) => h.email).equalTo(email)
      ..values = inputUser;
    final user = await userQuery.updateOne();
    if (user == null) {
      return Response.notFound();
    }
    return Response.ok(user);
  }

  // DELETE
  @Operation.delete('email')
  Future<Response> deleteUserByEmail(@Bind.path('email') String email) async {
    final userQuery = Query<User>(context)
      ..where((h) => h.email).equalTo(email);
    final user = await userQuery.delete();
    if (user == null) {
      return Response.notFound();
    }
    return Response.ok(user);
  }
}