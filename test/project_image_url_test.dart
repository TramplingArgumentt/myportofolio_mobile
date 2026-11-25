import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';

void main() {
  test('converts a Google Drive sharing link to a direct image URL', () {
    final imageUri = projectImageUri(
      'https://drive.google.com/file/d/drive-file-id/view?usp=sharing',
    );

    expect(
      imageUri,
      Uri.https('lh3.googleusercontent.com', '/d/drive-file-id=w1000'),
    );
  });

  test('converts a Google Drive link with an id query parameter', () {
    final imageUri = projectImageUri(
      'https://drive.google.com/open?id=drive-file-id',
    );

    expect(
      imageUri,
      Uri.https('lh3.googleusercontent.com', '/d/drive-file-id=w1000'),
    );
  });

  test('removes a size suffix accidentally appended to the file id', () {
    final imageUri = projectImageUri(
      'https://drive.google.com/thumbnail?id=drive-file-id=w1000',
    );

    expect(
      imageUri,
      Uri.https('lh3.googleusercontent.com', '/d/drive-file-id=w1000'),
    );
  });

  test('keeps non-Google-Drive image URLs unchanged', () {
    final imageUri = projectImageUri('https://example.com/image.png');

    expect(imageUri, Uri.parse('https://example.com/image.png'));
  });

  test('returns null for malformed or empty image URLs', () {
    expect(projectImageUri(''), isNull);
    expect(projectImageUri('not a URL'), isNull);
  });
}
