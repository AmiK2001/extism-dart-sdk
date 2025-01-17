import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/host_function.dart';
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:ffi/ffi.dart';

// CurrentPlugin class to manage interactions with the current plugin instance.
class CurrentPlugin {
  final Pointer<ExtismCurrentPlugin> _plugin;
  final Pointer<Void> _userData;

  CurrentPlugin(this._plugin, this._userData);

  HostFunction? get hostFunction {
    return HostFunction.userDataRegistry[_userData.address] as HostFunction?;
  }

  /// Get a value from the plugin's memory by its offset.
  ///
  /// [offset] is the memory offset to read from.
  /// Returns a [Uint8List] containing the data read from the memory.
  Uint8List memoryGet(int offset) {
    final length = extism.extism_current_plugin_memory_length(_plugin, offset);
    final ptr = extism.extism_current_plugin_memory(_plugin).cast<Uint8>();
    if (ptr == nullptr) {
      return Uint8List(0);
    }
    return ptr.asTypedList(length);
  }

  /// Allocate a new block of memory in the plugin's memory space.
  ///
  /// [length] is the size of the memory block to allocate.
  /// Returns the offset of the newly allocated memory block.
  int memoryAlloc(int length) {
    return extism.extism_current_plugin_memory_alloc(_plugin, length);
  }

  /// Free a previously allocated block of memory.
  ///
  /// [offset] is the offset of the memory block to free.
  void memoryFree(int offset) {
    extism.extism_current_plugin_memory_free(_plugin, offset);
  }

  /// Get the length of a memory block.
  ///
  /// [offset] is the offset of the memory block.
  /// Returns the length of the memory block.
  int memoryLength(int offset) {
    return extism.extism_current_plugin_memory_length(_plugin, offset);
  }

  /// Get a string from the plugin's memory by its offset.
  ///
  /// [offset] is the memory offset to read from.
  /// Returns a [String] containing the data read from the memory.
  String? memoryGetString(int offset) {
    final length = extism.extism_current_plugin_memory_length(_plugin, offset);
    final ptr = extism.extism_current_plugin_memory(_plugin).cast<Utf8>();
    if (ptr == nullptr) {
      return null;
    }
    return ptr.toDartString(length: length);
  }

  /// Returns the user data object that was passed in when a <see cref="HostFunction"/> was registered.
  T? getUserData<T>() {
    if (_userData == nullptr) {
      return null;
    }

    // Retrieve the object from the registry using the address
    return HostFunction.userDataRegistry[_userData.address] as T?;
  }

  /// Get the current plugin call's associated host context data. Returns null if call was made without host context.
  /// Get the current plugin call's associated host context data. Returns null if call was made without host context.
  T? getCallHostContext<T>() {
    final ptr = extism.extism_current_plugin_host_context(_plugin);
    if (ptr == nullptr) {
      return null;
    }

    // Retrieve the object from the registry using the address
    return HostFunction.userDataRegistry[ptr.address] as T?;
  }

  /// Returns a pointer to the memory of the currently running plugin.
  /// NOTE: this should only be called from host functions.
  Pointer<Uint8> getMemory() {
    return extism.extism_current_plugin_memory(_plugin).cast();
  }

  /// Reads a string from a memory block using UTF8.
  String readString(int offset) {
    return readStringWithEncoding(offset, utf8);
  }

  /// Reads a string from a memory block.
  String readStringWithEncoding(int offset, Encoding encoding) {
    final buffer = readBytes(offset);
    return encoding.decode(buffer);
  }

  /// Returns a list of bytes for a given block.
  Uint8List readBytes(int offset) {
    final mem = getMemory();
    final length = blockLength(offset);
    final ptr = mem + offset;
    return Uint8List.fromList(ptr.asTypedList(length));
  }

  /// Writes a string into the current plugin memory using UTF-8 encoding and returns the offset of the block.
  int writeString(String value) {
    return writeStringWithEncoding(value, utf8);
  }

  /// Writes a string into the current plugin memory and returns the offset of the block.
  int writeStringWithEncoding(String value, Encoding encoding) {
    final bytes = encoding.encode(value);
    final offset = allocateBlock(bytes.length);
    writeBytes(offset, bytes);
    return offset;
  }

  /// Writes a byte array into a newly allocated block of memory.
  /// Returns the offset of the allocated block
  int writeBytesList(Uint8List bytes) {
    final offset = allocateBlock(bytes.length);
    writeBytes(offset, bytes);
    return offset;
  }

  /// Writes a byte array into a block of memory.
  void writeBytes(int offset, List<int> bytes) {
    final length = blockLength(offset);
    if (length < bytes.length) {
      throw StateError(
        "Destination block length is less than source block length.",
      );
    }

    final mem = getMemory();
    final ptr = mem + offset;
    final destination = ptr.asTypedList(bytes.length);

    for (var i = 0; i < bytes.length; i++) {
      destination[i] = bytes[i];
    }
  }

  /// Frees a block of memory belonging to the current plugin.
  void freeBlock(int offset) {
    extism.extism_current_plugin_memory_free(_plugin, offset);
  }

  /// Allocate a memory block in the currently running plugin.
  int allocateBlock(int length) {
    return extism.extism_current_plugin_memory_alloc(_plugin, length);
  }

  /// Get the length of an allocated block.
  /// NOTE: this should only be called from host functions.
  int blockLength(int offset) {
    return extism.extism_current_plugin_memory_length(_plugin, offset);
  }
}
