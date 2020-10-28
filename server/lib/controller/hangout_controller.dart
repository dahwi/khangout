import 'package:aqueduct/aqueduct.dart';
import '../server.dart';

class HangoutController extends ResourceController {
  final _hangouts = [
    {'id': 11, 'name': 'Captain America'},
    {'id': 12, 'name': 'Ironman'},
    {'id': 13, 'name': 'Wonder Woman'},
    {'id': 14, 'name': 'Hulk'},
    {'id': 15, 'name': 'Black Widow'},
  ];

  @Operation.get()
  Future<Response> getAllHangouts() async {
    return Response.ok(_hangouts);
  }

  @Operation.get('id')
  // declare input parameter which is path(;id) and bind it as argument of type integer
  Future<Response> getHangoutByID(@Bind.path('id') int id) async {
    final hangout =
        _hangouts.firstWhere((h) => h['id'] == id, orElse: () => null);
    if (hangout == null) {
      return Response.notFound();
    }
    return Response.ok(hangout);
  }
}
