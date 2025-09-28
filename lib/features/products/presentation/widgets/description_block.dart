import 'package:flutter/material.dart';

class DescriptionBlock extends StatelessWidget {
  final String text;
  final bool expanded;
  final VoidCallback onToggle;
  const DescriptionBlock({
    super.key,
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final collapsed = text.length > 140 ? '${text.substring(0, 140)}...' : text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expanded ? text : collapsed,
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
          if (text.length > 140) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onToggle,
              child: Text(
                expanded ? 'Show Less' : 'Learn More',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
