import 'package:xpanca_ecommerce/core/utils/helper.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/widgets/qty_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.theme,
    required this.it,
  });

  final ThemeData theme;
  final CartItemView it;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(it.productId),
      direction: DismissDirection.endToStart,
      background: _buildBg(alignEnd: false),
      secondaryBackground: _buildBg(alignEnd: true),
      confirmDismiss: (direction) async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus item?'),
            content: Text('Hapus "${it.name}" dari keranjang?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        );
        if (ok == true) {
          context.read<CartBloc>().add(CartItemRemoved(it.productId));
          return true;
        }
        return false;
      },
      onDismissed: (_) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text('Item "${it.name}" dihapus'),
            action: SnackBarAction(
              label: 'Urungkan',
              onPressed: () {
                context
                    .read<CartBloc>()
                    .add(CartItemAdded(it.productId, it.qty));
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 58,
                child: it.thumbnail.isNotEmpty
                    ? Image.network(it.thumbnail, fit: BoxFit.cover)
                    : Container(
                        color: const Color(0xFFF0F1F4),
                        child: const Icon(Icons.image_outlined),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(it.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      )),
                  Text(it.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(rupiah(it.price),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          )),
                      QtyStepper(
                        value: it.qty,
                        onMinus: () {
                          final q = (it.qty - 1).clamp(1, 999);
                          context
                              .read<CartBloc>()
                              .add(CartQtyChanged(it.productId, q));
                        },
                        onPlus: () {
                          context
                              .read<CartBloc>()
                              .add(CartQtyChanged(it.productId, it.qty + 1));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBg({required bool alignEnd}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6E6),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD92D20)),
    );
  }
}
