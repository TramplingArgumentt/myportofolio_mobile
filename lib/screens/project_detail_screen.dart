import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

Uri? projectImageUri(String imageUrl) {
  final uri = Uri.tryParse(imageUrl.trim());
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    return null;
  }

  if (uri.host.toLowerCase() != 'drive.google.com') {
    return uri;
  }

  final pathSegments = uri.pathSegments;
  final rawFileId =
      pathSegments.length >= 3 &&
          pathSegments[0] == 'file' &&
          pathSegments[1] == 'd'
      ? pathSegments[2]
      : uri.queryParameters['id'];
  final fileId = rawFileId?.replaceFirst(RegExp(r'=w\d+$'), '');
  if (fileId == null || fileId.isEmpty) {
    return uri;
  }

  return Uri.https('lh3.googleusercontent.com', '/d/$fileId=w1000');
}

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  static const _paperColor = Color(0xFFFAF6F0);
  static const _inkColor = Color(0xFF1C1917);
  static const _accentColor = Color(0xFFD95D39);
  static const _accentDarkColor = Color(0xFFA8442A);
  static const _mutedColor = Color(0xFF6B6459);
  static const _lineColor = Color(0xFFE3D9C9);

  @override
  Widget build(BuildContext context) {
    final imageUri = projectImageUri(project.projectImageUrl);
    return Scaffold(
      backgroundColor: _paperColor,
      appBar: AppBar(
        title: const Text('Project Details'),
        backgroundColor: _paperColor,
        foregroundColor: _inkColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _lineColor),
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 3, color: _accentColor),
                  if (imageUri != null)
                    Image.network(
                      imageUri.toString(),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: const TextStyle(
                            color: _inkColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (project.tags.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: project.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: _lineColor),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        color: _inkColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          project.description,
                          style: const TextStyle(
                            color: _mutedColor,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        if (project.projectUrl.trim().isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Divider(color: _lineColor),
                          const SizedBox(height: 12),
                          const Text(
                            'Project URL',
                            style: TextStyle(
                              color: _inkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            project.projectUrl,
                            style: const TextStyle(
                              color: _accentDarkColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
