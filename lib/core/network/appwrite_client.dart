import 'package:appwrite/appwrite.dart';
import '../constants/api_endpoints.dart';

class AppwriteClient {
  static final Client _client = Client()
    ..setEndpoint(AW.endpoint)
    ..setProject(AW.projectId);

  static Client    get client    => _client;
  static Account   get account   => Account(_client);
  static Databases get databases => Databases(_client);
  static Storage   get storage   => Storage(_client);
  static Realtime  get realtime  => Realtime(_client);
  static Functions get functions => Functions(_client);
}
