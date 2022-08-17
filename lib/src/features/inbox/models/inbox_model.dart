class InboxModel {
  final String id;
  final String uid;
  final DateTime date;
  final String subject;
  final String content;
  final bool isSeen;

  const InboxModel({
    required this.id,
    required this.uid,
    required this.date,
    required this.subject,
    required this.content,
    required this.isSeen,
  });

  InboxModel.fromJson({required this.id, required Map<String, dynamic> json})
      : uid = json['uid'],
        date = DateTime.parse(json['date']),
        subject = json['subject'],
        content = json['content'],
        isSeen = json['isSeen'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'date': date.toIso8601String(),
        'subject': subject,
        'content': content,
        'isSeen': isSeen,
      };
}
