import 'package:get_storage/get_storage.dart';

class Storage {
  static final Storage _instance = Storage._internal();
  static late GetStorage _box;

  factory Storage() {
    return _instance;
  }

  Storage._internal() {
    _box = GetStorage();
  }

  Future<void> init() async {
    await _box.initStorage;
  }

  void write<T>(String key, T value) {
    _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  bool hasData(String key) {
    return _box.hasData(key);
  }

  void remove(String key) {
    _box.remove(key);
  }

  void clear() {
    _box.erase();
  }
}
