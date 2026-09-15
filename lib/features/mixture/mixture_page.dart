import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Расчёт смеси: сколько спирта и воды взять на нужный объём и крепость.
class MixturePage extends StatefulWidget {
  const MixturePage({super.key});

  @override
  State<MixturePage> createState() => _MixturePageState();
}

class _MixturePageState extends State<MixturePage>
    with AutomaticKeepAliveClientMixin {
  double _abv = 90;
  double _targetVolume = 250;
  double _targetAbv = 40;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = calcMixture(
      abv: _abv,
      targetVolume: _targetVolume,
      targetAbv: _targetAbv,
    );
    final tooStrong = _targetAbv > _abv;

    return CalcPage(
      title: 'Расчёт смеси',
      children: [
        ValueField(
          label: 'Крепость спирта',
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
          label: 'Нужный объём',
          value: _targetVolume,
          unit: 'мл',
          step: 50,
          min: 10,
          max: 100000,
          onChanged: (v) => setState(() => _targetVolume = v),
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
          icon: Icons.science_outlined,
          lines: [
            ResultLine(
              caption: 'Спирт',
              value: fmtNum(r.spirit),
              unit: 'мл',
              big: true,
            ),
            ResultLine(caption: 'Вода', value: fmtNum(r.water), unit: 'мл'),
          ],
          hint: tooStrong
              ? 'Нужная крепость выше крепости спирта — смесь не получится.'
              : null,
        ),
      ],
    );
  }
}
