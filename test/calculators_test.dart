import 'package:alcocalc/domain/calculators.dart';
import 'package:flutter_test/flutter_test.dart';

/// Контрольные значения взяты из Google-таблицы «Калькулятор самогона».
void main() {
  test('разбавление водой: 85 % / 500 мл -> 40 %', () {
    final r = calcDilution(abv: 85, volume: 500, targetAbv: 40);
    expect(r.totalVolume.round(), 1063);
    expect(r.water.round(), 563);
  });

  test('расчёт крепости: 40 % / 600 мл -> 1500 мл', () {
    final abv = calcFinalAbv(abv: 40, volume: 600, targetVolume: 1500);
    expect(abv, closeTo(16, 0.001));
  });

  test('расчёт смеси: 90 % -> 250 мл по 40 %', () {
    final r = calcMixture(abv: 90, targetVolume: 250, targetAbv: 40);
    expect(r.spirit.round(), 111);
    expect(r.water.round(), 139);
  });

  test('объём и вода: 40 % / 500 мл + 1500 мл воды', () {
    final r = calcWaterAdd(abv: 40, volume: 500, water: 1500);
    expect(r.abv, closeTo(10, 0.001));
    expect(r.totalVolume, 2000);
  });

  test('головы: 5000 мл сырца 30 %, отбор 10 % от АС', () {
    final r = calcHeads(abv: 30, volume: 5000, headsPercent: 10);
    expect(r.absoluteAlcohol, closeTo(1500, 0.001));
    expect(r.heads, closeTo(150, 0.001));
    expect(r.rest, closeTo(4850, 0.001));
  });

  test('хвосты: 5000 мл сырца 30 %, головы 10 %, хвосты 15 %, тело 65 %', () {
    final r = calcTails(
      abv: 30,
      volume: 5000,
      headsPercent: 10,
      tailsPercent: 15,
      bodyAbv: 65,
    );
    expect(r.tails, closeTo(225, 0.001));
    expect(r.bodyAlcohol, closeTo(1125, 0.001));
    expect(r.bodyVolume, closeTo(1730.769, 0.01));
  });

  test('отсечка по температуре: узел и интерполяция', () {
    final node = calcByCubeTemp(92);
    expect(node.cubeAbv, closeTo(12.2, 0.001));
    expect(node.outputAbv, closeTo(57.9, 0.001));

    final between = calcByCubeTemp(92.5);
    expect(between.cubeAbv, closeTo(11.2, 0.001));
    expect(between.outputAbv, closeTo(55.75, 0.001));

    expect(calcByCubeTemp(85).inRange, isFalse);
  });

  test('два напитка: 50 % / 1000 мл + 60 % / 1000 мл', () {
    final r = calcBlend(abv1: 50, volume1: 1000, abv2: 60, volume2: 1000);
    expect(r.abv, closeTo(55, 0.001));
    expect(r.totalVolume, 2000);
  });
}
