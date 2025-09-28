import 'package:json_annotation/json_annotation.dart';

part 'api_envelope.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiEnvelope<T> {
  final bool success;
  final T? data;
  final ApiError? error;
  final Pagination? pagination;
  final Map<String, dynamic>? meta;

  const ApiEnvelope({
    required this.success,
    this.data,
    this.error,
    this.pagination,
    this.meta,
  });

  String? get requestId => meta?['request_id'] as String?;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiEnvelopeFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiEnvelopeToJson(this, toJsonT);
}

@JsonSerializable()
class ApiError {
  final String code;
  final String message;
  final dynamic details;

  const ApiError({required this.code, required this.message, this.details});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'page_size')
  final int pageSize;
  final int total;
  @JsonKey(name: 'total_pages')
  final int totalPages;

  const Pagination({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable()
class MessageModel {
  final String? message;

  MessageModel({this.message});

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
