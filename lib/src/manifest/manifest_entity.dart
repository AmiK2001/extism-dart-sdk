import 'dart:convert';

import 'package:extism/src/manifest.dart';
import 'package:extism/src/wasm/wasm_source.dart';

///The `Manifest` type is used to configure the runtime and specify how to load modules.
final class ManifestEntity {
  ///Specifies which hosts may be accessed via HTTP, if this is empty then no hosts may be
  ///accessed. Wildcards may be used.
  final List<String>? allowedHosts;

  ///Specifies which paths should be made available on disk when using WASI. This is a mapping
  ///from the path on disk to the path it should be available inside the plugin. For example,
  ///`".": "/tmp"` would mount the current directory as `/tmp` inside the module
  final Map<String, String>? allowedPaths;

  ///Config values are made accessible using the PDK `extism_config_get` function
  final Map<String, String>? config;

  ///Memory options
  final MemoryOptions? memory;

  ///The plugin timeout in milliseconds
  final int? timeoutMs;

  ///WebAssembly modules, the `main` module should be named `main` or listed last
  final List<WasmSource>? wasm;

  ManifestEntity({
    this.allowedHosts,
    this.allowedPaths,
    this.config,
    this.memory,
    this.timeoutMs,
    this.wasm,
  });
}

extension ManifestExtension on ManifestEntity {
  List<int> bytes() {
    final manifestData = Manifest(
      allowedHosts: allowedHosts,
      allowedPaths: allowedPaths,
      config: config,
      memory: memory,
      timeoutMs: timeoutMs,
      wasm: wasm?.map((it) => it.toWasm()).toList(),
    );

    return jsonEncode(manifestData).runes.toList();
  }
}
