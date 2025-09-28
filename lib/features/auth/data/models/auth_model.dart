import 'package:xpanca_ecommerce/features/auth/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthPayloadModel {
  final String token;
  final UserModel user;

  const AuthPayloadModel({
    required this.token,
    required this.user,
  });

  factory AuthPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$AuthPayloadModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthPayloadModelToJson(this);

  Auth toEntity() => Auth(token: token, user: user.toEntity());
}
