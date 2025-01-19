import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:extism/src/manifest.dart';

sealed class WasmSource {
  final String name;
  final String hash;

  WasmSource({
    required this.name,
    required this.hash,
  });

  factory WasmSource.fromBytes({
    required String name,
    required Uint8List data,
  }) {
    final hash = sha256.convert(data).toString();

    return ByteArrayWasmSource(
      name: name,
      hash: hash,
      data: data,
    );
  }

  factory WasmSource.fromUrl({
    required String name,
    required Uri url,
    required String hash,
  }) {
    return UrlWasmSource(
      name: name,
      hash: hash,
      url: url,
    );
  }

  factory WasmSource.fromPath({
    required String name,
    required String path,
  }) {
    final data = File(path).readAsBytesSync();
    final hash = sha256.convert(data).toString();

    return PathWasmSource(
      name: name,
      hash: hash,
      path: path,
    );
  }
}

final class ByteArrayWasmSource extends WasmSource {
  final Uint8List data;

  ByteArrayWasmSource({
    required super.name,
    required super.hash,
    required this.data,
  });
}

final class UrlWasmSource extends WasmSource {
  final Uri url;

  UrlWasmSource({
    required super.name,
    required super.hash,
    required this.url,
  });
}

final class PathWasmSource extends WasmSource {
  final String path;

  PathWasmSource({
    required super.name,
    required super.hash,
    required this.path,
  });
}

extension WasmSourceExtension on WasmSource {
  Wasm toWasm() {
    return switch (this) {
      final ByteArrayWasmSource source => Wasm(
          name: source.name,
          hash: source.hash,
          data: base64Encode(source.data),
        ),
      final UrlWasmSource source => Wasm(
          name: source.name,
          hash: source.hash,
          url: source.url.toString(),
        ),
      final PathWasmSource source => Wasm(
          name: source.name,
          hash: source.hash,
          path: source.path,
        ),
    };
  }
}
