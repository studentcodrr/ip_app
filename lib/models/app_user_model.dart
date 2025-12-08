import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'app_user_model.freezed.dart';
part 'app_user_model.g.dart';

@freezed
class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    required String id,
    required String email,
    required String displayName,
    @Default('') String photoUrl,
  }) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) => _$AppUserModelFromJson(json);

  factory AppUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AppUserModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}