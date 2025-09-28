import 'package:xpanca_ecommerce/core/utils/typedefs.dart';

abstract class UsecaseWithParams<T, P> {
  const UsecaseWithParams();
  ResultFuture<T> call(P params);
}

abstract class UsecaseWithoutParams<T> {
  const UsecaseWithoutParams();
  ResultFuture<T> call();
}
