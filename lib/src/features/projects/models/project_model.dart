import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String image;
  final int totalTasks;
  final int doneTasks;
  final List<String> tasks;
  final List<String> crew;
  final bool isFavorite;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.image,
    required this.totalTasks,
    required this.doneTasks,
    required this.tasks,
    required this.crew,
    required this.isFavorite,
  });

  ProjectModel.fromJson({
    required this.id,
    required Map<String, dynamic> json,
    required this.isFavorite,
  })  : title = json['title'],
        description = json['description'],
        date = (json['date'] as Timestamp).toDate(),
        image = json['image'],
        totalTasks = json['totalTasks'],
        doneTasks = json['doneTasks'],
        tasks = List<String>.from(json['tasks']),
        crew = List<String>.from(json['crew']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'image': image,
        'totalTasks': totalTasks,
        'doneTasks': doneTasks,
      };
}
