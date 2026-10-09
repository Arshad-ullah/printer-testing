import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/network_service.dart';
import '../services/socket_server_service.dart';
import 'providers.dart';
import 'server_state.dart';

class ServerViewModel extends Notifier<ServerState> {
  StreamSubscription? _messageSubscription;

  @override
  ServerState build() {
    ref.onDispose(() {
      _messageSubscription?.cancel();
    });

    // Run initialization after initial frame/microtask
    Future.microtask(() => initNetworkAndServer());

    return const ServerState();
  }

  NetworkService get _networkService => ref.read(networkServiceProvider);
  SocketServerService get _socketServerService =>
      ref.read(socketServerServiceProvider);

  Future<void> initNetworkAndServer() async {
    await detectIp();
    await startServer(port: state.port);
  }

  Future<void> detectIp() async {
    try {
      final ips = await _networkService.getLocalIpAddresses();
      state = state.copyWith(
        allIps: ips,
        myIp: ips.isNotEmpty ? ips.first : 'No Wi-Fi/Hotspot IP',
      );
    } catch (e) {
      state = state.copyWith(
        myIp: 'Error detecting IP: $e',
      );
    }
  }

  Future<void> startServer({int? port}) async {
    final serverPort = port ?? state.port;
    try {
      await _socketServerService.start(serverPort);

      // Listen for incoming messages
      await _messageSubscription?.cancel();
      _messageSubscription = _socketServerService.messageStream.listen(
        (message) {
          state = state.copyWith(
            messages: [message, ...state.messages],
          );
        },
      );

      state = state.copyWith(
        port: serverPort,
        isServerRunning: true,
        clearServerError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isServerRunning: false,
        serverError: e.toString(),
      );
    }
  }

  Future<void> stopServer() async {
    await _socketServerService.stop();
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    state = state.copyWith(isServerRunning: false);
  }

  Future<void> refreshNetwork() async {
    await detectIp();
    if (!state.isServerRunning) {
      await startServer(port: state.port);
    }
  }

  void clearMessages() {
    state = state.copyWith(messages: const []);
  }
}
