import 'package:xpanca_ecommerce/core/shared/widgets/circle_button.dart';
import 'package:xpanca_ecommerce/core/utils/helper.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/product.dart';
import 'package:xpanca_ecommerce/features/products/presentation/widgets/heart_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.p,
  });

  final Product p;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/products/${p.id}'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                // height: (w / crossAxisCount),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: p.thumbnailUrl == '' || p.thumbnailUrl.isEmpty
                            ? const ColoredBox(
                                color: Color(0xFFF0F0F0),
                                child: Icon(Icons.image, size: 48),
                              )
                            : Image.network(
                                p.thumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: HeartBadge(
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    p.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                          height: 1.0,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rupiah(p.price),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      CircleButton(
                          onTap: () => context.read<CartBloc>().add(
                                CartItemAdded(
                                  p.id,
                                  1,
                                ),
                              ),
                          icon: Iconsax.shopping_cart)
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
}
