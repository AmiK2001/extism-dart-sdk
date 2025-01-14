import 'dart:typed_data';

import 'package:crypto/crypto.dart';

sealed class WasmSource {
  String get name;
  String get hash;
}

class ByteArrayWasmSource extends WasmSource {
  final String _name;
  final Uint8List _data;

  ByteArrayWasmSource({
    required String name,
    required Uint8List data,
  })  : _name = name,
        _data = data;

  @override
  String get name => _name;

  @override
  String get hash => sha256.convert(_data).toString();
}
