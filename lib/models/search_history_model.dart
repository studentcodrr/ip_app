import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'search_history_model.freezed.dart';
part 'search_history_model.g.dart';

@freezed
class SearchHistoryModel with _$SearchHistoryModel {
  const factory SearchHistoryModel({
    required String id,
    @Default('Unknown Prompt') String description, // <input> // Added Default
    @Default('') String strategy,                  // <input> // Added Default
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

// Robust Timestamp Conversion
DateTime _fromJsonTimestamp(dynamic timestamp) {
  if (timestamp == null) return DateTime.now(); // Handle optimistic UI (pending write)
  if (timestamp is Timestamp) return timestamp.toDate(); // Handle standard Firestore Timestamp
  return DateTime.now(); // Fallback for any other garbage data
}

dynamic _toJsonTimestamp(DateTime date) => Timestamp.fromDate(date);