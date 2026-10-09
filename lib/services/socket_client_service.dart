import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/transfer_payload.dart';

class SocketClientService {
  static const Duration defaultTimeout = Duration(seconds: 4);

  Future<void> sendPayload({
    required String targetIp,
    required int port,
    required TransferPayload payload,
    Duration timeout = defaultTimeout,
  }) async {
    final socket = await Socket.connect(targetIp, port, timeout: timeout);
    try {
      final jsonString = jsonEncode(payload.toJson());
      socket.add(utf8.encode(jsonString));
      await socket.flush();
    } finally {
      await socket.close();
    }
  }

  Future<void> sendRawBytes({
    required String targetIp,
    required int port,
    required List<int> bytes,
    Duration timeout = defaultTimeout,
  }) async {
    final socket = await Socket.connect(targetIp, port, timeout: timeout);
    try {
      socket.add(bytes);
      await socket.flush();
    } finally {
      await socket.close();
    }
  }
}
