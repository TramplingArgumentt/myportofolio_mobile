import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

class _ProjectTagsClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(
        utf8.encode(
          '[{"id":"a7ac9a65-e3bb-4874-8e98-151b4e3106ad","name":"Flutter"},'
          '{"id":"41078f7c-5f2d-43e9-9bd0-74be4d951c05","name":"Django"}]',
        ),
      ),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  testWidgets(
    'project form loads tags as independently selectable checkboxes',
    (tester) async {
      final apiClient = ApiClient(
        client: _ProjectTagsClient(),
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
          child: const MaterialApp(home: ProjectFormPage()),
        ),
      );
      await tester.pumpAndSettle();

      final flutterOption = find.widgetWithText(CheckboxListTile, 'Flutter');
      final djangoOption = find.widgetWithText(CheckboxListTile, 'Django');
      expect(flutterOption, findsOneWidget);
      expect(djangoOption, findsOneWidget);

      await tester.tap(flutterOption);
      await tester.pump();
      await tester.tap(djangoOption);
      await tester.pump();

      expect(tester.widget<CheckboxListTile>(flutterOption).value, isTrue);
      expect(tester.widget<CheckboxListTile>(djangoOption).value, isTrue);
    },
  );
}
