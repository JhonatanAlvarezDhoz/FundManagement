/// Simula el paso del tiempo
/// 1 segundo = 1 día
class TimeSimulator {
  DateTime _current = DateTime.now();

  DateTime get current => _current;

  void tick() {
    _current = _current.add(const Duration(days: 1));
  }
}
