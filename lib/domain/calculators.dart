/// Чистые функции расчёта. Повторяют формулы Google-таблицы
/// «Калькулятор самогона»: объёмы складываются линейно, контракция
/// (сжатие спирто-водяной смеси) не учитывается.
library;

/// Разбавление водой: есть V мл крепости [abv], нужна крепость [targetAbv].
class DilutionResult {
  const DilutionResult({required this.water, required this.totalVolume});

  /// Сколько воды долить, мл.
  final double water;

  /// Итоговый объём, мл.
  final double totalVolume;
}

DilutionResult calcDilution({
  required double abv,
  required double volume,
  required double targetAbv,
}) {
  if (abv <= 0 || volume <= 0 || targetAbv <= 0) {
    return const DilutionResult(water: 0, totalVolume: 0);
  }
  final total = volume * abv / targetAbv;
  final water = total - volume;
  return DilutionResult(
    water: water < 0 ? 0 : water,
    totalVolume: total < volume ? volume : total,
  );
}

/// Расчёт крепости: V мл крепости [abv] доводим до объёма [targetVolume].
double calcFinalAbv({
  required double abv,
  required double volume,
  required double targetVolume,
}) {
  if (targetVolume <= 0) return 0;
  final result = abv * volume / targetVolume;
  return result > abv ? abv : result;
}

/// Расчёт смеси: из спирта крепости [abv] нужно получить
/// [targetVolume] мл крепости [targetAbv].
class MixtureResult {
  const MixtureResult({required this.spirit, required this.water});

  /// Сколько спирта взять, мл.
  final double spirit;

  /// Сколько воды долить, мл.
  final double water;
}

MixtureResult calcMixture({
  required double abv,
  required double targetVolume,
  required double targetAbv,
}) {
  if (abv <= 0 || targetVolume <= 0 || targetAbv <= 0) {
    return const MixtureResult(spirit: 0, water: 0);
  }
  final spirit = targetVolume * targetAbv / abv;
  if (spirit >= targetVolume) {
    return MixtureResult(spirit: targetVolume, water: 0);
  }
  return MixtureResult(spirit: spirit, water: targetVolume - spirit);
}

/// Крепость и объём: к V мл крепости [abv] добавили [water] мл воды.
class WaterAddResult {
  const WaterAddResult({required this.abv, required this.totalVolume});

  final double abv;
  final double totalVolume;
}

WaterAddResult calcWaterAdd({
  required double abv,
  required double volume,
  required double water,
}) {
  final total = volume + water;
  if (total <= 0) return const WaterAddResult(abv: 0, totalVolume: 0);
  return WaterAddResult(abv: abv * volume / total, totalVolume: total);
}

/// Смешивание двух напитков разной крепости.
class BlendResult {
  const BlendResult({required this.abv, required this.totalVolume});

  final double abv;
  final double totalVolume;
}

BlendResult calcBlend({
  required double abv1,
  required double volume1,
  required double abv2,
  required double volume2,
}) {
  final total = volume1 + volume2;
  if (total <= 0) return const BlendResult(abv: 0, totalVolume: 0);
  return BlendResult(
    abv: (abv1 * volume1 + abv2 * volume2) / total,
    totalVolume: total,
  );
}
