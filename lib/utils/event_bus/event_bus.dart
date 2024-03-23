class EventBus {
  EventBus._privateConstructor();
  static final EventBus _instance = EventBus._privateConstructor();
  factory EventBus() {
    return _instance;
  }

  static final Map<String, List<Function>> _events = {};
  static void on(String eventName, Function callback) {
    if (_events.containsKey(eventName)) {
      _events[eventName]!.add(callback);
    } else {
      _events[eventName] = [callback];
    }
  }

  static void off(String eventName, Function callback) {
    if (_events.containsKey(eventName)) {
      _events[eventName]!.remove(callback);
    }
  }

  static void fire(String eventName, [dynamic data]) {
    if (_events.containsKey(eventName)) {
      for (var callback in _events[eventName]!) {
        callback(data);
      }
    }
  }
}
