/// Форматирование чисел: запятая как десятичный разделитель,
/// хвостовые нули убираются.
String fmtNum(double value, {int decimals = 0}) {
  if (value.isNaN || value.isInfinite) return '—';
  var s = value.toStringAsFixed(decimals);
  if (decimals > 0 && s.contains('.')) {
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
  }
  return s.replaceAll('.', ',');
}

/// Разбор пользовательского ввода: принимает и точку, и запятую.
double? parseNum(String raw) {
  final cleaned = raw.trim().replaceAll(',', '.').replaceAll(' ', '');
  if (cleaned.isEmpty) return null;
  return double.tryParse(cleaned);
}
