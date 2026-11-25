import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/models/project_tag.dart';

void main() {
  test('Project JSON uses the backend name field', () {
    const project = Project(
      title: 'Portofolio',
      description: 'Deskripsi proyek',
      tags: ['tag-id'],
      projectUrl: 'https://example.com',
    );

    final json = project.toJson();

    expect(json['name'], 'Portofolio');
    expect(json.containsKey('title'), isFalse);
    expect(
      Project.fromJson({
        'name': 'Portofolio',
        'description': 'Deskripsi proyek',
        'tags': ['Tag'],
        'project_url': 'https://example.com',
        'project_image_url': '',
      }).title,
      'Portofolio',
    );
  });

  test('ProjectTag parses the API id and name', () {
    const tag = ProjectTag(
      id: 'a7ac9a65-e3bb-4874-8e98-151b4e3106ad',
      name: 'Flutter',
    );

    final parsedTag = ProjectTag.fromJson({'id': tag.id, 'name': tag.name});

    expect(parsedTag.id, tag.id);
    expect(parsedTag.name, tag.name);
  });
}
