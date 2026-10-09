import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/escpos_service.dart';
import '../services/image_picker_service.dart';
import '../services/network_service.dart';
import '../services/socket_client_service.dart';
import '../services/socket_server_service.dart';
import 'sender_state.dart';
import 'sender_viewmodel.dart';
import 'server_state.dart';
import 'server_viewmodel.dart';

// Services
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

final socketServerServiceProvider = Provider<SocketServerService>((ref) {
  final service = SocketServerService();
  ref.onDispose(() => service.dispose());
  return service;
});

final socketClientServiceProvider = Provider<SocketClientService>((ref) {
  return SocketClientService();
});

final escPosServiceProvider = Provider<EscPosService>((ref) {
  return EscPosService();
});

final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService();
});

// ViewModels
final serverProvider = NotifierProvider<ServerViewModel, ServerState>(
  ServerViewModel.new,
);

final senderProvider = NotifierProvider<SenderViewModel, SenderState>(
  SenderViewModel.new,
);
