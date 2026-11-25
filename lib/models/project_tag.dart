class ProjectTag {
  const ProjectTag({required this.id, required this.name});

  factory ProjectTag.fromJson(Map<String, dynamic> json) =>
      ProjectTag(id: json['id'] as String, name: json['name'] as String);

  final String id;
  final String name;
}
