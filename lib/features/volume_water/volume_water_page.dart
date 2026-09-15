import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Объём и вода: к напитку доливают известное количество воды.
class VolumeWaterPage extends StatefulWidget {
  const VolumeWaterPage({super.key});

  @override
  State<VolumeWaterPage> createState() => _VolumeWaterPageState();
}

class _VolumeWaterPageState extends State<VolumeWaterPage>
    with AutomaticKeepAliveClientMixin {
  double _abv = 40;
  double _volume = 500;
  double _water = 1500;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = calcWaterAdd(abv: _abv, volume: _volume, water: _water);

    return CalcPage(
      title: 'Объём и вода',
      children: [
        ValueField(
          label: 'Крепость',
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
          label: 'Объём воды',
          value: _water,
          unit: 'мл',
          step: 50,
          min: 0,
          max: 200000,
          onChanged: (v) => setState(() => _water = v),
        ),
        const SizedBox(height: 20),
        ResultCard(
          accent: AppColors.teal,
          icon: Icons.opacity,
          lines: [
            ResultLine(
              caption: 'Итоговая крепость',
              value: fmtNum(r.abv, decimals: 1),
              unit: '%',
              big: true,
            ),
            ResultLine(
              caption: 'Итоговый объём',
              value: fmtNum(r.totalVolume),
              unit: 'мл',
            ),
          ],
        ),
      ],
    );
  }
}
