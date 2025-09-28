import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../bloc/cart_bloc.dart';

class CartBadge extends StatelessWidget {
  final VoidCallback onTap;
  const CartBadge({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (c, s) {
      return IconButton(
        onPressed: onTap,
        icon: Badge(
          label: Text('${s.items.length}'),
          child: const Icon(Iconsax.shopping_cart),
        ),
      );
    });
  }
}
