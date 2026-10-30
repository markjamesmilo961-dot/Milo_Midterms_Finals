mixin Loggable {
  void log(String message) {
    final t = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    print('[${two(t.hour)}:${two(t.minute)}:${two(t.second)}] [$runtimeType] $message');
  }
}
