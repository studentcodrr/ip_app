import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required String id,
    required String name,
    required String description,
    required String ownerId,
    @Default(0xFF42A5F5) int colorValue,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    required DateTime createdAt,
    
    //<input> // NEW FIELDS (Required for Audit Feature)
    @Default(0) int auditScore,
    @Default('') String auditFeedback,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return ProjectModel(
      id: doc.id, 
      name: data['name'] as String? ?? 'Untitled Project',
      description: data['description'] as String? ?? '',
      ownerId: data['ownerId'] as String? ?? '',
      colorValue: (data['colorValue'] as int?) ?? 0xFF42A5F5,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      
      //<input> // Map from Firestore
      auditScore: (data['auditScore'] as int?) ?? 0,
      auditFeedback: (data['auditFeedback'] as String?) ?? '',
    );
  }
}

DateTime _fromJsonTimestamp(dynamic timestamp) => (timestamp as Timestamp).toDate();
dynamic _toJsonTimestamp(DateTime date) => Timestamp.fromDate(date);