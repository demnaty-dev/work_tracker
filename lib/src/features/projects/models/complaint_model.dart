import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String id;
  final String title;
  final String complaint;
  final DateTime date;
  final String createdBy;

  ComplaintModel.fromJson({
    required this.id,
    required Map<String, dynamic> json,
  })  : title = json['title'],
        complaint = json['complaint'],
        date = (json['date'] as Timestamp).toDate(),
        createdBy = json['createdBy'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'complaint': complaint,
        'date': date.toIso8601String(),
        'createdBy': createdBy,
      };
}
