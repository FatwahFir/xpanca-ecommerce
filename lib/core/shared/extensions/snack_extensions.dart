import 'package:flutter/material.dart';

enum SnackType { info, success, warning, error }

extension SnackContext on BuildContext {
  void showSnack(
    String msg, {
    SnackType type = SnackType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    EdgeInsetsGeometry? margin,
  }) {
    final cs = Theme.of(this).colorScheme;
    final bg = switch (type) {
      SnackType.success => cs.primaryContainer,
      SnackType.warning => cs.tertiaryContainer,
      SnackType.error => cs.errorContainer,
      SnackType.info => const Color(0xFF222222),
    };

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(fontSize: 13)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: bg,
          margin: margin ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: duration,
          action: action,
        ),
      );
  }
}
