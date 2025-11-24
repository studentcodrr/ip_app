import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'search_history_model.freezed.dart';
part 'search_history_model.g.dart';

@freezed
class SearchHistoryModel with _$SearchHistoryModel {
  const factory SearchHistoryModel({
    required String id,
    required String description,
    required String strategy,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    required DateTime createdAt,
  }) = _SearchHistoryModel;

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) => _$SearchHistoryModelFromJson(json);

  factory SearchHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SearchHistoryModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

DateTime _fromJsonTimestamp(dynamic timestamp) => (timestamp as Timestamp).toDate();
dynamic _toJsonTimestamp(DateTime date) => Timestamp.fromDate(date);