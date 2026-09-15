import 'package:flutter/material.dart';

import '../theme.dart';

/// Общий каркас вкладки: заголовок, поля ввода, карточка результата.
class CalcPage extends StatelessWidget {
  const CalcPage({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

/// Подпись группы полей с цветной меткой (как в макете).
class GroupLabel extends StatelessWidget {
  const GroupLabel({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 12.5,
              letterSpacing: 0.8,
              color: AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}
