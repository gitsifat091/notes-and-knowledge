import 'package:flutter/material.dart';

class NeuCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const NeuCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap});
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final lightShadow = dark ? const Color(0xFF363B46) : Colors.white;
    final darkShadow = dark ? const Color(0xFF1A1D22) : const Color(0xFFB3BAC5);
    return GestureDetector(onTap: onTap, child: Container(
      padding: padding,
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: darkShadow, offset: const Offset(6, 6), blurRadius: 12),
          BoxShadow(color: lightShadow, offset: const Offset(-6, -6), blurRadius: 12)]),
      child: child,
    ));
  }
}
