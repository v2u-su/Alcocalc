import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Разбавление водой: сколько воды долить до нужной крепости.
class DilutionPage extends StatefulWidget {
  const DilutionPage({super.key});

  @override
  State<DilutionPage> createState() => _DilutionPageState();
}

class _DilutionPageState extends State<DilutionPage>
    with AutomaticKeepAliveClientMixin {
  double _abv = 85;
  double _volume = 500;
  double _targetAbv = 40;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = calcDilution(abv: _abv, volume: _volume, targetAbv: _targetAbv);
    final tooStrong = _targetAbv > _abv;

    return CalcPage(
      title: 'Разбавление водой',
      children: [
        ValueField(
          label: 'Исходная крепость',
          value: _abv,
          unit: '%',
          decimals: 1,
          step: 1,
          min: 1,
          max: 96.6,
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
          onChanged: (v) => setState(() => _volume = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Нужная крепость',
          value: _targetAbv,
          unit: '%',
          decimals: 1,
          step: 1,
          min: 1,
          max: 96.6,
          onChanged: (v) => setState(() => _targetAbv = v),
        ),
        const SizedBox(height: 20),
        ResultCard(
          accent: AppColors.teal,
          icon: Icons.water_drop_outlined,
          lines: [
            ResultLine(
              caption: 'Долить воды',
              value: fmtNum(r.water),
              unit: 'мл',
              big: true,
            ),
            ResultLine(
              caption: 'Итоговый объём',
              value: fmtNum(r.totalVolume),
              unit: 'мл',
            ),
          ],
          hint: tooStrong
              ? 'Нужная крепость выше исходной — водой её не поднять.'
              : null,
        ),
      ],
    );
  }
}
