import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../format.dart';
import '../theme.dart';

/// Строка ввода: подпись, кнопки «−» / «+» и значение.
/// Тап по значению открывает ручной ввод, удержание кнопки — автоповтор.
class ValueField extends StatefulWidget {
  const ValueField({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
    this.max = 100000,
    this.decimals = 0,
    this.accent = AppColors.teal,
  });

  final String label;
  final double value;
  final String unit;
  final ValueChanged<double> onChanged;
  final double step;
  final double min;
  final double max;
  final int decimals;
  final Color accent;

  @override
  State<ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  Timer? _repeater;

  @override
  void dispose() {
    _repeater?.cancel();
    super.dispose();
  }

  void _apply(double delta) {
    final raw = widget.value + delta;
    final clamped = raw.clamp(widget.min, widget.max).toDouble();
    final rounded =
        double.parse(clamped.toStringAsFixed(widget.decimals + 2));
    if (rounded != widget.value) {
      HapticFeedback.selectionClick();
      widget.onChanged(rounded);
    }
  }

  void _startRepeat(double delta) {
    _apply(delta);
    _repeater?.cancel();
    _repeater = Timer(const Duration(milliseconds: 380), () {
      _repeater = Timer.periodic(
        const Duration(milliseconds: 70),
        (_) => _apply(delta),
      );
    });
  }

  void _stopRepeat() {
    _repeater?.cancel();
    _repeater = null;
  }

  Future<void> _editManually() async {
    final controller = TextEditingController(
      text: fmtNum(widget.value, decimals: widget.decimals),
    );
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.label),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType:
              TextInputType.numberWithOptions(decimal: widget.decimals > 0),
          decoration: InputDecoration(
            suffixText: widget.unit,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (text) =>
              Navigator.of(context).pop(parseNum(text)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(parseNum(controller.text)),
            child: const Text('Готово'),
          ),
        ],
      ),
    );
    if (result != null) {
      widget.onChanged(result.clamp(widget.min, widget.max).toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.15,
                    letterSpacing: 0.4,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
          ),
          _StepButton(
            icon: Icons.remove,
            onDown: () => _startRepeat(-widget.step),
            onUp: _stopRepeat,
          ),
          Expanded(
            flex: 42,
            child: GestureDetector(
              onTap: _editManually,
              child: Container(
                color: AppColors.fieldInner,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${fmtNum(widget.value, decimals: widget.decimals)} ${widget.unit}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            onDown: () => _startRepeat(widget.step),
            onUp: _stopRepeat,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onDown,
    required this.onUp,
  });

  final IconData icon;
  final VoidCallback onDown;
  final VoidCallback onUp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      onTapCancel: onUp,
      child: SizedBox(
        width: 48,
        child: Icon(icon, size: 24, color: AppColors.textDim),
      ),
    );
  }
}
