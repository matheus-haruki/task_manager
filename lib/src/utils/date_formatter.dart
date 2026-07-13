extension DateFormatter on DateTime {
  String get formatted {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    final h = hour.toString().padLeft(2, '0');
    final min = minute.toString().padLeft(2, '0');
    return '$d/$m/$year $h:$min';
  }
}
