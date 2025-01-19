import 'dart:convert';
import 'dart:io';

import 'package:extism/extism.dart';
import 'package:test/test.dart';

void main() {
  // Ensure the WASM file exists
  setUpAll(() {
    const wasmFilePath = "test/resources/http.wasm";
    if (!File(wasmFilePath).existsSync()) {
      throw StateError(
        "WASM file not found at $wasmFilePath. Please compile the WASM module before running tests.",
      );
    }
  });

  test('Successful HTTP GET request', () {
    final plugin = Plugin.initWithManifest(
      manifest: ManifestEntity(
        allowedHosts: [
          "jsonplaceholder.typicode.com",
        ],
        wasm: [
          WasmSource.fromPath(
            name: 'main',
            path: "test/resources/http.wasm",
          ),
        ],
      ),
      withWasi: false,
    );

    final httpRequestJson = jsonEncode(
      HttpRequest(
        url: "https://jsonplaceholder.typicode.com/todos/1",
        method: "GET",
        headers: {},
      ),
    );

    final response = plugin.callString(
      "http_get",
      httpRequestJson,
    );

    final responseJson = jsonDecode(response);

    expect(responseJson['userId'], isNotNull);
    expect(responseJson['id'], isNotNull);
    expect(responseJson['title'], isNotNull);
    expect(responseJson['completed'], isNotNull);

    plugin.dispose();
  });
}
