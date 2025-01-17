import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

Pointer<Char> enumToPtr<T extends Enum>(T value) {
  final name = value.name;
  final units = utf8.encode(name);
  final ptr = calloc<Char>(units.length + 1); // +1 for null terminator

  for (var i = 0; i < units.length; i++) {
    ptr[i] = units[i];
  }
  ptr[units.length] = 0; // Null terminator

  return ptr.cast();
}

/// Extism Log Levels
enum LogLevel {
  /// Designates very serious errors.
  error,

  /// Designates hazardous situations.
  warn,

  /// Designates useful information.
  info,

  /// Designates lower priority information.
  debug,

  /// Designates very low priority, often extremely verbose, information.
  trace,
}
