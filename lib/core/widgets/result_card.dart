import 'package:flutter/material.dart';

import '../theme.dart';

class ResultLine {
  const ResultLine({
    required this.caption,
    required this.value,
    required this.unit,
    this.big = false,
  });

  final String caption;
  final String value;
  final String unit;
  final bool big;
}

/// Карточка результата — подсвеченный блок внизу экрана.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.accent,
    required this.icon,
    required this.lines,
    this.hint,
  });

  final Color accent;
  final IconData icon;
  final List<ResultLine> lines;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent, width: 1.6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(AppColors.bar, accent, 0.30)!,
            Color.lerp(AppColors.bar, accent, 0.10)!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            _LineView(line: lines[i], accent: accent, icon: i == 0 ? icon : null),
          ],
          if (hint != null) ...[
            const SizedBox(height: 14),
            Text(
              hint!,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textDim),
            ),
          ],
        ],
      ),
    );
  }
}

class _LineView extends StatelessWidget {
  const _LineView({required this.line, required this.accent, this.icon});

  final ResultLine line;
  final Color accent;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: accent),
              const SizedBox(width: 7),
            ],
            Flexible(
              child: Text(
                line.caption.toUpperCase(),
                style: TextStyle(
                  fontSize: 12.5,
                  letterSpacing: 0.6,
                  color: accent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                line.value,
                style: TextStyle(
                  fontSize: line.big ? 44 : 30,
                  height: 1.05,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                line.unit,
                style: TextStyle(
                  fontSize: line.big ? 22 : 17,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
