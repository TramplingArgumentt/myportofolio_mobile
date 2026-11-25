import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

class _ProjectResponseClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(
        utf8.encode(
          '[{"id":"a7ac9a65-e3bb-4874-8e98-151b4e3106ad",'
          '"name":"Portfolio","description":"Personal projects",'
          '"tags":["Flutter"],"project_url":"","project_image_url":""}]',
        ),
      ),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  testWidgets('project list loads API data and opens its detail screen', (
    tester,
  ) async {
    final apiClient = ApiClient(
      client: _ProjectResponseClient(),
      baseUrl: 'https://example.test',
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          ChangeNotifierProvider(
            create: (_) => AuthState(apiClient, initialToken: 'test-token'),
          ),
        ],
        child: const MaterialApp(home: ProjectListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final projectTile = find.widgetWithText(ListTile, 'Portfolio');
    expect(projectTile, findsOneWidget);
    expect(find.text('Flutter\nPersonal projects'), findsOneWidget);

    await tester.tap(projectTile);
    await tester.pumpAndSettle();

    expect(find.text('Project Details'), findsOneWidget);
    expect(find.text('Personal projects'), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsNothing);
  });
}
