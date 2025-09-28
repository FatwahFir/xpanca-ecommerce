import 'package:xpanca_ecommerce/core/shared/extensions/snack_extensions.dart';
import 'package:xpanca_ecommerce/core/shared/widgets/custom_back_button.dart';
import 'package:xpanca_ecommerce/core/shared/widgets/gradient_button.dart';
import 'package:xpanca_ecommerce/core/shared/widgets/circle_button.dart';
import 'package:xpanca_ecommerce/features/products/presentation/widgets/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../cart/presentation/widgets/cart_badge.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/product_detail_bloc.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final int id;
  const ProductDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 45,
        surfaceTintColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CustomBackButton(),
        ),
        title: Text(
          'Detail',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [CartBadge(onTap: () => context.push('/cart'))],
      ),
      body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
        listenWhen: (prev, curr) =>
            prev.error != curr.error && curr.error != null,
        listener: (context, state) {
          if (state.error != null) {
            context.showSnack(state.error!);
          }
        },
        builder: (c, s) {
          if (s.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.error != null) {
            context.showSnack(s.error!);
            return const SizedBox.shrink();
          }

          final p = s.product;
          if (p == null) {
            context.read<ProductDetailBloc>().add(ProductDetailOpened(id));
            return const SizedBox.shrink();
          }
          return DetailContent(product: p);
        },
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final p = context.select<ProductDetailBloc, Product?>(
            (b) => b.state.product,
          );
          if (p == null) return const SizedBox.shrink();

          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Row(
                spacing: 10,
                children: [
                  CircleButton(
                    onTap: () {},
                    icon: Icons.favorite_outline_rounded,
                  ),
                  Expanded(
                    child: GradientButton(
                      onTap: () => context.read<CartBloc>().add(
                            CartItemAdded(p.id, 1),
                          ),
                      text: 'Add To Cart',
                      icon: Iconsax.shopping_cart,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      extendBody: true,
    );
  }
}
