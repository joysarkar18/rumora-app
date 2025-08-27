import 'package:campus_crush_app/services/logger_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:typesense/typesense.dart';

class TypeSenseInstance {
  late final Configuration config;
  late final Client client;

  bool _isConfigInitialized = false;

  static final TypeSenseInstance _instance = TypeSenseInstance._internal();
  TypeSenseInstance._internal();
  factory TypeSenseInstance() => _instance;

  Future<void> initialize() async {
    try {
      if (_isConfigInitialized) {
        return;
      }

      final value = await FirebaseFirestore.instance
          .collection('settings')
          .doc('typesense')
          .get();

      var keys = value.data();
      if (keys == null) {
        throw Exception('TypeSense config not found in Firebase');
      }

      config = Configuration(
        keys['searchOnlyKey'].toString(),
        nodes: {Node(Protocol.https, keys['host'].toString(), port: 443)},
        connectionTimeout: Duration(seconds: 50),
      );

      client = Client(config);
      _isConfigInitialized = true;
      LoggerService.logInfo("TypeSenseInstance Created");
    } catch (e) {
      rethrow;
    }
  }

  bool get isInitialized => _isConfigInitialized;

  Future<void> ensureInitialized() async {
    if (!isInitialized) await initialize();
  }
}
