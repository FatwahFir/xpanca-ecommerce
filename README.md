# Simple E-Commerce

**Stack:** Flutter 3.27, BLoC, Retrofit/Dio, GoRouter, GetIt, dartz & equatable, json_serializable, flutter_secure_storage.

**Compatible With:** Mobile(Android), Desktop(Windows), and Web

## Quick start

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

Edit host in `lib/main.dart` to match your Go backend.

## Layers

`datasource → repository → usecase → bloc → UI` with DI.
