import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Смешивание двух напитков разной крепости.
class TwoDrinksPage extends StatefulWidget {
  const TwoDrinksPage({super.key});

  @override
  State<TwoDrinksPage> createState() => _TwoDrinksPageState();
}

class _TwoDrinksPageState extends State<TwoDrinksPage>
    with AutomaticKeepAliveClientMixin {
  double _abv1 = 50;
  double _volume1 = 1000;
  double _abv2 = 60;
  double _volume2 = 1000;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = calcBlend(
      abv1: _abv1,
      volume1: _volume1,
      abv2: _abv2,
      volume2: _volume2,
    );

    return CalcPage(
      title: 'Смешивание двух крепостей',
      children: [
        const GroupLabel(text: 'Напиток 1', color: AppColors.teal),
        ValueField(
          label: 'Крепость',
          value: _abv1,
          unit: '%',
          decimals: 1,
          step: 1,
          min: 0,
          max: 96.6,
          onChanged: (v) => setState(() => _abv1 = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Объём',
          value: _volume1,
          unit: 'мл',
          step: 50,
          min: 0,
          max: 200000,
          onChanged: (v) => setState(() => _volume1 = v),
        ),
        const SizedBox(height: 18),
        const GroupLabel(text: 'Напиток 2', color: AppColors.amber),
        ValueField(
          label: 'Крепость',
          value: _abv2,
          unit: '%',
          decimals: 1,
          step: 1,
          min: 0,
          max: 96.6,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _abv2 = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Объём',
          value: _volume2,
          unit: 'мл',
          step: 50,
          min: 0,
          max: 200000,
          accent: AppColors.amber,
          onChanged: (v) => setState(() => _volume2 = v),
        ),
        const SizedBox(height: 20),
        ResultCard(
          accent: AppColors.amber,
          icon: Icons.auto_awesome,
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
