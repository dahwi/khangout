import 'controller/hangout_controller.dart';
import 'controller/userHangout_controller.dart';
import 'controller/user_controller.dart';
import 'server.dart';

/// This type initializes an application.
///
/// Application needs to know two things to execute database queries:
/// 1. What is the data model
/// 2. What databae to connect to
class ServerChannel extends ApplicationChannel {
  ManagedContext context;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    // load config.yaml and use its values to set up out database connection
    final config = HangoutConfig(options.configurationFilePath);

    // find all of our ManagedObject<T> subclasses and compile them into a data model
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    // PostgresSQLPersistentStore takes database connection information that will be used to
    // connect and send queries to a database
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);

    context = ManagedContext(dataModel, persistentStore);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    router.route('/hangouts/[:id]').link(() => HangoutController(context));
    router.route('/users/[:email]').link(() => UserController(context));
    router
        .route('/userhangouts/[:id]')
        .link(() => UserHangoutController(context));

    return router;
  }
}

class HangoutConfig extends Configuration {
  HangoutConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
