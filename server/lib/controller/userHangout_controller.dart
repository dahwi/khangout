import 'package:aqueduct/aqueduct.dart';
import '../model/user_hangout.dart';
import '../server.dart';

class UserHangoutController extends ResourceController {
  UserHangoutController(this.context);

  final ManagedContext context;

  // GET
  // get a list of hangouts
  @Operation.get()
  Future<Response> getAllUserHangouts() async {
    final hangoutQuery = Query<UserHangouts>(context);
    final hangouts = await hangoutQuery.fetch();

    return Response.ok(hangouts);
  }

  // // get a single hangout by its id
  // @Operation.get('id')
  // // declare input parameter which is path('id') and bind it as argument of type integer
  // Future<Response> getHangoutByID(@Bind.path('id') int id) async {
  //   final hangoutQuery = Query<Hangout>(context)
  //     ..where((h) => h.id).equalTo(id);
  //   final hangout = await hangoutQuery.fetchOne();
  //   if (hangout == null) {
  //     return Response.notFound();
  //   }
  //   return Response.ok(hangout);
  // }

  // POST; Insert new hangout info into the database
  // The request will contain the JSON representation of a hangout in its body
  //@Bind.body() List<int> userHangout
  @Operation.post()
  Future<Response> createUserHangout(@Bind.body() UserHangouts userHangout) async {
    final userHangoutQuery = Query<UserHangouts>(context)
      ..values = userHangout;

    final insertedUserHangout = await userHangoutQuery.insert();
    return Response.ok(insertedUserHangout);
  }

  // // PUT
  // @Operation.put('id')
  // Future<Response> updateHangoutById(
  //     @Bind.path('id') int id, @Bind.body() Hangout inputHangout) async {
  //   final hangoutQuery = Query<Hangout>(context)
  //     ..where((h) => h.id).equalTo(id)
  //     ..values = inputHangout;
  //   final hangout = await hangoutQuery.updateOne();
  //   if (hangout == null) {
  //     return Response.notFound();
  //   }
  //   return Response.ok(hangout);
  // }

  // // DELETE
  // @Operation.delete('id')
  // Future<Response> deleteHangoutByID(@Bind.path('id') int id) async {
  //   final hangoutQuery = Query<Hangout>(context)
  //     ..where((h) => h.id).equalTo(id);
  //   final hangout = await hangoutQuery.delete();
  //   if (hangout == null) {
  //     return Response.notFound();
  //   }
  //   return Response.ok(hangout);
  // }
}
