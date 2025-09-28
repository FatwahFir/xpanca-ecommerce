import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.pop(),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE5E5E5),
            width: 0.8,
          ),
        ),
        child: const Icon(
          Iconsax.arrow_left,
          size: 18,
          color: Colors.black87,
        ),
      ),
    );
  }
}
