import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Отсечка по температуре в кубе: крепость в кубе и в струе.
class CubeTempPage extends StatefulWidget {
  const CubeTempPage({super.key});

  @override
  State<CubeTempPage> createState() => _CubeTempPageState();
}

class _CubeTempPageState extends State<CubeTempPage>
    with AutomaticKeepAliveClientMixin {
  double _temp = 96;

  @override
  bool get wantKeepAlive => true;

  String _phase(double t, bool inRange) {
    if (!inRange) {
      return 'Ниже 88 °C таблица не идёт: в кубе больше 22 %, отсечка ещё '
          'далеко.';
    }
    if (t <= 94) return 'Идёт тело, до хвостов есть запас.';
    if (t <= 96) {
      return 'Подход к отсечке: на 96 °C в струе около 37 %, обычная точка '
          'смены тары.';
    }
    if (t < 98) return 'Хвосты.';
    return 'В кубе 1–2 % спирта — пора заканчивать отбор.';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = calcByCubeTemp(_temp);

    return CalcPage(
      title: 'Отсечка по температуре',
      children: [
        ValueField(
          label: 'Температура в кубе',
          value: _temp,
          unit: '°C',
          decimals: 1,
          step: 0.5,
          min: 80,
          max: 100,
          onChanged: (v) => setState(() => _temp = v),
        ),
        const SizedBox(height: 20),
        ResultCard(
          accent: AppColors.teal,
          icon: Icons.device_thermostat,
          lines: [
            ResultLine(
              caption: 'Крепость в струе',
              value: fmtNum(r.outputAbv, decimals: 1),
              unit: '%',
              big: true,
              icon: Icons.water_drop_outlined,
            ),
            ResultLine(
              caption: 'Крепость в кубе',
              value: fmtNum(r.cubeAbv, decimals: 1),
              unit: '%',
              big: true,
              icon: Icons.science_outlined,
            ),
          ],
          hint: '${_phase(_temp, r.inRange)}\n\nТаблица для 760 мм рт. ст. '
              'и откалиброванного термометра. Дефлегмация под крышкой куба '
              'поднимает реальную крепость в струе — сверяйся с ареометром.',
        ),
      ],
    );
  }
}
