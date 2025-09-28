import 'package:xpanca_ecommerce/app/di/injector.dart';
import 'package:xpanca_ecommerce/core/services/secure_storage.dart';
import 'package:xpanca_ecommerce/core/shared/extensions/snack_extensions.dart';
import 'package:xpanca_ecommerce/core/shared/widgets/custom_back_button.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/widgets/cart_item_list.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/widgets/summary_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/formatters.dart';
import '../bloc/cart_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _discountCtrl = TextEditingController();

  @override
  void dispose() {
    _discountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 45,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CustomBackButton(),
        ),
        title: Text(
          'My Cart',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocListener<CartBloc, CartState>(
        listenWhen: (p, n) =>
            p.status != n.status && n.status == CartStatus.failure,
        listener: (context, s) {
          if (s.error != null && s.error!.isNotEmpty) {
            print(s.error);
            context.showSnack(s.error!);
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, s) {
            if (s.status == CartStatus.loading && s.items.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              ));
            }

            if (s.items.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<CartBloc>().add(CartRefreshed()),
                child: ListView(
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('Keranjang kosong')),
                  ],
                ),
              );
            }

            final discount = 0;
            final subtotal = s.subtotal;
            final total = (subtotal - discount).clamp(0, double.infinity);

            return LayoutBuilder(
              builder: (context, constraints) {
                const desktopBp = 900.0;
                final isDesktop = constraints.maxWidth >= desktopBp;

                final itemsList = RefreshIndicator(
                  onRefresh: () async =>
                      context.read<CartBloc>().add(CartRefreshed()),
                  child: CartItemsList(s: s, theme: theme),
                );

                final summary = SummaryPanel(
                  subtotal: subtotal,
                  discount: discount,
                  total: total,
                  onCheckout: () async {
                    final user = await sl<SecureStorage>().readUser();
                    final items = s.items
                        .map((e) => {
                              'name': e.name,
                              'qty': e.qty,
                              'price': e.price,
                            })
                        .toList();

                    final msg = WhatsApp.checkoutMessage(
                      customerName: user?.username ?? '-',
                      items: items,
                      subtotal: subtotal,
                    );
                    final uri = WhatsApp.waUri(
                      phone: '6283821177545',
                      message: msg,
                    );
                    launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                  discountCtrl: _discountCtrl,
                );

                if (!isDesktop) {
                  return Column(
                    children: [
                      Expanded(child: itemsList),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: summary,
                      ),
                    ],
                  );
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: itemsList,
                            ),
                          ),
                          const SizedBox(width: 20),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 320,
                              maxWidth: 380,
                            ),
                            child: summary,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
