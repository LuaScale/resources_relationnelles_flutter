import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> writeSecureData(var key, var value) async {
    await _secureStorage.write(
        key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    var readData =
    await _secureStorage.read(key: key);
    return readData;
  }
}
