import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  final String id;
  final DateTime date;
  final String subject;
  final String content;
  final bool isSeen;
  final bool isFavorite;
  final List<String>? urls;

  const InboxModel({
    required this.id,
    required this.date,
    required this.subject,
    required this.content,
    required this.isSeen,
    required this.isFavorite,
    this.urls,
  });

  InboxModel.fromJson({required this.id, required Map<String, dynamic> json})
      : date = (json['date'] as Timestamp).toDate(),
        subject = json['subject'],
        content = json['content'],
        isSeen = json['isSeen'],
        isFavorite = json['isFavorite'],
        urls = json['urls'] != null ? List<String>.from(json['urls']) : null;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'subject': subject,
        'content': content,
        'isSeen': isSeen,
        'isFavorite': isFavorite,
      };
}
