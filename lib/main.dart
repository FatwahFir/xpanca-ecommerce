import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'core/theme/app_theme.dart';
import 'app/router/app_router.dart';
import 'app/di/injector.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  await initDI('http://192.168.1.3:8080/api/v1');

  final authBloc = sl<AuthBloc>()..add(AuthCheckStatus());
  final router = AppRouter.build(authBloc);

  runApp(MyApp(router: router, authBloc: authBloc));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  final AuthBloc authBloc;
  const MyApp({super.key, required this.router, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, n) => p.authenticated != n.authenticated,
        listener: (context, s) {
          final cartBloc = sl<CartBloc>();
          if (s.authenticated) {
            cartBloc.add(CartReset());
            cartBloc.add(CartStarted());
          } else {
            cartBloc.add(CartReset());
          }
        },
        child: MaterialApp.router(
          title: 'Simple ecommerce',
          debugShowCheckedModeBanner: false,
          theme: appTheme(context),
          routerConfig: router,
        ),
      ),
    );
  }
}
