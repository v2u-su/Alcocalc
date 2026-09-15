import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Расчёт крепости: какая крепость получится, если довести объём до нужного.
class StrengthPage extends StatefulWidget {
  const StrengthPage({super.key});

  @override
  State<StrengthPage> createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage>
    with AutomaticKeepAliveClientMixin {
  double _abv = 40;
  double _volume = 600;
  double _targetVolume = 1500;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final abv = calcFinalAbv(
      abv: _abv,
      volume: _volume,
      targetVolume: _targetVolume,
    );
    final water = _targetVolume - _volume;

    return CalcPage(
      title: 'Расчёт крепости',
      children: [
        ValueField(
          label: 'Крепость',
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
          label: 'Объём',
          value: _volume,
          unit: 'мл',
          step: 50,
          min: 10,
          max: 100000,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _volume = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Нужный объём',
          value: _targetVolume,
          unit: 'мл',
          step: 50,
          min: 10,
          max: 200000,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _targetVolume = v),
        ),
        const SizedBox(height: 20),
        ResultCard(
          accent: AppColors.amber,
          icon: Icons.thermostat,
          lines: [
            ResultLine(
              caption: 'Итоговая крепость',
              value: fmtNum(abv, decimals: 1),
              unit: '%',
              big: true,
            ),
          ],
          hint: water >= 0
              ? 'Долить воды: ${fmtNum(water)} мл'
              : 'Нужный объём меньше исходного — разбавления не будет.',
        ),
      ],
    );
  }
}
