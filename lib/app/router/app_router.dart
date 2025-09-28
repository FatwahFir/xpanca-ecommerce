import 'dart:async';
import 'package:xpanca_ecommerce/app/di/injector.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:xpanca_ecommerce/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:xpanca_ecommerce/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/products/presentation/pages/home_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';

class AppRouter {
  static GoRouter build(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: BlocStreamListenable(authBloc.stream),
      redirect: (context, state) {
        final authed = authBloc.state.authenticated;
        final loggingIn = state.matchedLocation == '/login';
        if (!authed && !loggingIn) return '/login';
        if (authed && loggingIn) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, __) => BlocProvider.value(
            value: authBloc,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) {
            final cartBloc = sl<CartBloc>();
            if (cartBloc.state.status == CartStatus.idle) {
              cartBloc.add(CartStarted());
            }
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      sl<ProductListBloc>()..add(ProductListFetched()),
                ),
                BlocProvider.value(value: cartBloc),
              ],
              child: const HomePage(),
            );
          },
          routes: [
            GoRoute(
              path: 'products/:id',
              builder: (_, s) {
                final cartBloc = sl<CartBloc>();
                if (cartBloc.state.status == CartStatus.idle) {
                  cartBloc.add(CartStarted());
                }
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<ProductDetailBloc>()),
                    BlocProvider.value(value: cartBloc),
                  ],
                  child: ProductDetailPage(
                    id: int.parse(s.pathParameters['id']!),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/cart',
          builder: (_, __) {
            final cartBloc = sl<CartBloc>();
            if (cartBloc.state.status == CartStatus.idle) {
              cartBloc.add(CartStarted());
            }
            return BlocProvider.value(
              value: cartBloc,
              child: const CartPage(),
            );
          },
        ),
      ],
    );
  }
}

class BlocStreamListenable extends ChangeNotifier {
  late final StreamSubscription _sub;
  BlocStreamListenable(Stream stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
