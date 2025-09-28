import 'package:flutter/material.dart';

class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FFF6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1F7E7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _roundIcon(onPressed: onMinus, icon: Icons.remove),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          _roundIcon(
            onPressed: onPlus,
            icon: Icons.add,
            filled: true,
          ),
        ],
      ),
    );
  }

  Widget _roundIcon({
    required VoidCallback onPressed,
    required IconData icon,
    bool filled = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF22C55E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1F7E7)),
        ),
        child: Icon(
          icon,
          size: 14,
          color: filled ? Colors.white : const Color(0xFF22C55E),
        ),
      ),
    );
  }
}
