import 'package:flutter/material.dart';

class HeartBadge extends StatefulWidget {
  const HeartBadge({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  State<HeartBadge> createState() => _HeartBadgeState();
}

class _HeartBadgeState extends State<HeartBadge> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          setState(() => liked = !liked);
          widget.onTap?.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? Colors.pink : Colors.black54,
            size: 18,
          ),
        ),
      ),
    );
  }
}
