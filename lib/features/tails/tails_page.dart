import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Калькулятор хвостов: сколько уйдёт в хвосты и что останется в теле.
class TailsPage extends StatefulWidget {
  const TailsPage({super.key});

  @override
  State<TailsPage> createState() => _TailsPageState();
}

class _TailsPageState extends State<TailsPage>
    with AutomaticKeepAliveClientMixin {
  double _volume = 5000;
  double _abv = 30;
  double _headsPercent = 10;
  double _tailsPercent = 15;
  double _bodyAbv = 65;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = calcTails(
      abv: _abv,
      volume: _volume,
      headsPercent: _headsPercent,
      tailsPercent: _tailsPercent,
      bodyAbv: _bodyAbv,
    );
    final overrun = _headsPercent + _tailsPercent >= 100;

    return CalcPage(
      title: 'Калькулятор хвостов',
      children: [
        ValueField(
          label: 'Объём сырца',
          value: _volume,
          unit: 'мл',
          step: 100,
          min: 100,
          max: 200000,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _volume = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Крепость сырца',
          value: _abv,
          unit: '%',
          decimals: 1,
          step: 1,
          min: 1,
          max: 96.6,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _abv = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Головы',
          value: _headsPercent,
          unit: '% от АС',
          step: 1,
          min: 0,
          max: 30,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _headsPercent = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Хвосты',
          value: _tailsPercent,
          unit: '% от АС',
          step: 1,
          min: 0,
          max: 40,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _tailsPercent = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Крепость тела',
          value: _bodyAbv,
          unit: '%',
          decimals: 1,
          step: 1,
          min: 10,
          max: 96.6,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _bodyAbv = v),
        ),
        const SizedBox(height: 20),
        ResultCard(
          accent: AppColors.amber,
          icon: Icons.vertical_align_bottom,
          lines: [
            ResultLine(
              caption: 'В хвосты',
              value: fmtNum(r.tails),
              unit: 'мл',
              big: true,
              icon: Icons.vertical_align_bottom,
            ),
            ResultLine(
              caption: 'Объём тела',
              value: fmtNum(r.bodyVolume),
              unit: 'мл',
              big: true,
              icon: Icons.science_outlined,
            ),
            ResultLine(
              caption: 'Спирт в теле',
              value: fmtNum(r.bodyAlcohol),
              unit: 'мл АС',
              icon: Icons.water_drop_outlined,
            ),
          ],
          hint: overrun
              ? 'Головы и хвосты съели весь спирт — проверь проценты.'
              : 'Отсечку хвостов делают по крепости в струе (обычно 40–45 %) '
                  'или по температуре в кубе 92–94 °C. Расчёт даёт ориентир '
                  'по объёму.',
        ),
      ],
    );
  }
}
