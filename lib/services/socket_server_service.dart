import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/received_message.dart';
import '../models/transfer_payload.dart';

class SocketServerService {
  ServerSocket? _serverSocket;
  final StreamController<ReceivedMessage> _messageStreamController =
      StreamController<ReceivedMessage>.broadcast();

  Stream<ReceivedMessage> get messageStream => _messageStreamController.stream;
  bool get isRunning => _serverSocket != null;

  Future<void> start(int port) async {
    await stop();

    _serverSocket = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      port,
      shared: true,
    );

    _serverSocket?.listen(
      (Socket clientSocket) {
        final senderIp = clientSocket.remoteAddress.address;
        final List<int> buffer = [];

        clientSocket.listen(
          (List<int> data) {
            buffer.addAll(data);
          },
          onDone: () {
            if (buffer.isNotEmpty) {
              final rawString = utf8.decode(buffer, allowMalformed: true);
              final payload = TransferPayload.fromRaw(rawString);
              _messageStreamController.add(
                ReceivedMessage(
                  senderIp: senderIp,
                  payload: payload,
                  receivedAt: DateTime.now(),
                ),
              );
            }
            clientSocket.destroy();
          },
          onError: (_) {
            clientSocket.destroy();
          },
          cancelOnError: true,
        );
      },
    );
  }

  Future<void> stop() async {
    await _serverSocket?.close();
    _serverSocket = null;
  }

  void dispose() {
    stop();
    _messageStreamController.close();
  }
}
