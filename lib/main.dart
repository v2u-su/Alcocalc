import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/dilution/dilution_page.dart';
import 'features/mixture/mixture_page.dart';
import 'features/strength/strength_page.dart';
import 'features/two_drinks/two_drinks_page.dart';
import 'features/volume_water/volume_water_page.dart';

void main() => runApp(const AlcoCalcApp());

class AlcoCalcApp extends StatelessWidget {
  const AlcoCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор самогона',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.icon, this.accent, this.page);

  final String label;
  final IconData icon;
  final Color accent;
  final Widget page;
}

const _tabs = <_TabSpec>[
  _TabSpec('Разбавление\nводой', Icons.water_drop_outlined, AppColors.teal,
      DilutionPage()),
  _TabSpec('Расчёт\nкрепости', Icons.thermostat, AppColors.amber,
      StrengthPage()),
  _TabSpec('Расчёт\nсмеси', Icons.layers_outlined, AppColors.teal,
      MixturePage()),
  _TabSpec('Объём\nи вода', Icons.opacity, AppColors.teal, VolumeWaterPage()),
  _TabSpec('Два\nнапитка', Icons.science_outlined, AppColors.amber,
      TwoDrinksPage()),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller =
      TabController(length: _tabs.length, vsync: this)
        ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = _tabs[_controller.index].accent;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(78),
        child: Material(
          color: AppColors.bar,
          child: SafeArea(
            bottom: false,
            child: TabBar(
              controller: _controller,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: accent,
              unselectedLabelColor: AppColors.textDim,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              indicatorColor: accent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 6),
              labelStyle: const TextStyle(fontSize: 11.5, height: 1.15),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 11.5, height: 1.15),
              tabs: [
                for (final tab in _tabs)
                  Tab(
                    height: 74,
                    icon: Icon(tab.icon, size: 22),
                    child: SizedBox(
                      width: 74,
                      child: Text(tab.label, textAlign: TextAlign.center),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [for (final tab in _tabs) tab.page],
      ),
    );
  }
}
