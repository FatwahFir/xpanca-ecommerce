import 'package:xpanca_ecommerce/app/di/injector.dart';
import 'package:xpanca_ecommerce/core/shared/extensions/snack_extensions.dart';
import 'package:xpanca_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/widgets/cart_badge.dart';
import 'package:xpanca_ecommerce/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:xpanca_ecommerce/core/shared/widgets/circle_button.dart';
import 'package:xpanca_ecommerce/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  static const _scrollThreshold = 320.0;

  final List<({String label, String value})> _sortOptions = const [
    (label: 'Terbaru', value: ''),
    (label: 'Nama A → Z', value: 'name_asc'),
    (label: 'Nama Z → A', value: 'name_desc'),
    (label: 'Harga termurah → termahal', value: 'price_asc'),
    (label: 'Harga termahal → termurah', value: 'price_desc'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final max = _scrollCtrl.position.maxScrollExtent;
      final offset = _scrollCtrl.offset;
      if (max - offset <= _scrollThreshold) {
        context.read<ProductListBloc>().add(ProductListLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            sl<CartBloc>().add(CartReset());
            sl<AuthBloc>().add(AuthLogoutRequested());
          },
          icon: const Icon(Iconsax.logout),
        ),
        title: Text(
          'Products',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CartBadge(onTap: () => context.push('/cart')),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (q) {
                      context.read<ProductListBloc>().add(ProductListFetched(
                          search: q.trim().isEmpty ? null : q.trim()));
                      _scrollCtrl.animateTo(0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search..',
                      hintStyle:
                          const TextStyle(color: Colors.black54, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      prefixIcon: const Icon(Iconsax.search_normal,
                          size: 18, color: Colors.black54),
                      prefixIconConstraints: const BoxConstraints(minWidth: 48),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: Color(0xFFE5E5E5), width: 0.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: Color(0xFFE5E5E5), width: 0.8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD), width: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleButton(
                  onTap: () => _openSortSheet(context),
                  icon: Icons.tune_rounded,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<ProductListBloc, ProductListState>(
              listenWhen: (prev, curr) =>
                  prev.error != curr.error && curr.error != null,
              listener: (context, state) {
                if (state.error != null) context.showSnack(state.error!);
              },
              builder: (context, state) {
                if (state.loading && state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = state.items;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final crossAxisCount = w >= 1200
                        ? 6
                        : w >= 840
                            ? 4
                            : w >= 600
                                ? 3
                                : 2;

                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<ProductListBloc>().add(
                                ProductListFetched(
                                  search: state.search,
                                  sort: state.sort,
                                ),
                              ),
                      child: Stack(
                        children: [
                          GridView.builder(
                            controller: _scrollCtrl,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: w / crossAxisCount,
                              mainAxisExtent: (w / crossAxisCount) * 1.66,
                            ),
                            itemCount: items.length,
                            itemBuilder: (_, i) => ProductCard(p: items[i]),
                          ),
                          if (state.loadingMore)
                            const Positioned.fill(
                              child: IgnorePointer(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSortSheet(BuildContext context) async {
    final bloc = context.read<ProductListBloc>();
    final current = bloc.state.sort ?? '';
    final theme = Theme.of(context);

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text('Urutkan',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ..._sortOptions.map((opt) {
                return RadioListTile<String>(
                  value: opt.value,
                  groupValue: current,
                  onChanged: (v) => Navigator.of(context).pop(v),
                  title: Text(opt.label),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  dense: true,
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected == null) return;
    bloc.add(ProductListFetched(
      search: bloc.state.search,
      sort: (selected.isEmpty) ? null : selected,
    ));
    if (mounted) {
      _scrollCtrl.animateTo(0,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }
}
