import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../core/widgets/calc_page.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/value_field.dart';
import '../../domain/calculators.dart';

/// Калькулятор голов: сколько отобрать на втором перегоне.
class HeadsPage extends StatefulWidget {
  const HeadsPage({super.key});

  @override
  State<HeadsPage> createState() => _HeadsPageState();
}

class _HeadsPageState extends State<HeadsPage>
    with AutomaticKeepAliveClientMixin {
  double _volume = 5000;
  double _abv = 30;
  double _headsPercent = 10;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final r = calcHeads(
      abv: _abv,
      volume: _volume,
      headsPercent: _headsPercent,
    );

    return CalcPage(
      title: 'Калькулятор голов',
      children: [
        ValueField(
          label: 'Объём сырца',
          value: _volume,
          unit: 'мл',
          step: 100,
          min: 100,
          max: 200000,
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
          onChanged: (v) => setState(() => _abv = v),
        ),
        const SizedBox(height: 12),
        ValueField(
          label: 'Отбор голов',
          value: _headsPercent,
          unit: '% от АС',
          step: 1,
          min: 1,
          max: 30,
          onChanged: (v) => setState(() => _headsPercent = v),
        ),
        const SizedBox(height: 20),
        ResultCard(
          accent: AppColors.teal,
          icon: Icons.content_cut,
          lines: [
            ResultLine(
              caption: 'Отобрать в головы',
              value: fmtNum(r.heads),
              unit: 'мл',
              big: true,
              icon: Icons.content_cut,
            ),
            ResultLine(
              caption: 'Абсолютный спирт',
              value: fmtNum(r.absoluteAlcohol),
              unit: 'мл',
              icon: Icons.water_drop_outlined,
            ),
            ResultLine(
              caption: 'Останется сырца',
              value: fmtNum(r.rest),
              unit: 'мл',
              icon: Icons.science_outlined,
            ),
          ],
          hint: 'Головы считают от абсолютного спирта: 5 % при покапельном '
              'отборе, 10 % — обычный запас, 15 % — с перестраховкой.',
        ),
      ],
    );
  }
}
