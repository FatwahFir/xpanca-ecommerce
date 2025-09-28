import 'package:xpanca_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:flutter/material.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key, required this.s, required this.theme});
  final CartState s;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      itemCount: s.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final it = s.items[i];
        return CartItemTile(theme: theme, it: it);
      },
    );
  }
}
