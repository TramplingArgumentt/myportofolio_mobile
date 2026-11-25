import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/services/api_client.dart';

class _TagResponseClient extends http.BaseClient {
  Uri? requestedUri;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUri = request.url;
    return http.StreamedResponse(
      Stream.value(
        utf8.encode(
          '[{"id":"a7ac9a65-e3bb-4874-8e98-151b4e3106ad","name":"Flutter"}]',
        ),
      ),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

class _TokenResponseClient extends http.BaseClient {
  String? requestBody;
  String? contentType;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final streamedRequest = request as http.Request;
    requestBody = streamedRequest.body;
    contentType = request.headers['content-type'];
    return http.StreamedResponse(
      Stream.value(utf8.encode('{"token":"test-token"}')),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  test('getProjectTags fetches and parses database tag options', () async {
    final client = _TagResponseClient();
    final apiClient = ApiClient(
      client: client,
      baseUrl: 'https://example.test',
    );

    final tags = await apiClient.getProjectTags();

    expect(client.requestedUri, Uri.parse('https://example.test/api/v1/tags/'));
    expect(tags, hasLength(1));
    expect(tags.single.id, 'a7ac9a65-e3bb-4874-8e98-151b4e3106ad');
    expect(tags.single.name, 'Flutter');
  });

  test('obtainToken sends credentials as JSON', () async {
    final client = _TokenResponseClient();
    final apiClient = ApiClient(
      client: client,
      baseUrl: 'https://example.test',
    );

    final token = await apiClient.obtainToken('evan', 'password');

    expect(token, 'test-token');
    expect(client.contentType, 'application/json');
    expect(jsonDecode(client.requestBody!), {
      'username': 'evan',
      'password': 'password',
    });
  });
}
