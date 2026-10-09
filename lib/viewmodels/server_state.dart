import 'package:equatable/equatable.dart';
import '../models/received_message.dart';

class ServerState extends Equatable {
  final String myIp;
  final List<String> allIps;
  final bool isServerRunning;
  final String? serverError;
  final int port;
  final List<ReceivedMessage> messages;

  const ServerState({
    this.myIp = 'Detecting...',
    this.allIps = const [],
    this.isServerRunning = false,
    this.serverError,
    this.port = 4040,
    this.messages = const [],
  });

  ServerState copyWith({
    String? myIp,
    List<String>? allIps,
    bool? isServerRunning,
    String? serverError,
    bool clearServerError = false,
    int? port,
    List<ReceivedMessage>? messages,
  }) {
    return ServerState(
      myIp: myIp ?? this.myIp,
      allIps: allIps ?? this.allIps,
      isServerRunning: isServerRunning ?? this.isServerRunning,
      serverError: clearServerError ? null : (serverError ?? this.serverError),
      port: port ?? this.port,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
    myIp,
    allIps,
    isServerRunning,
    serverError,
    port,
    messages,
  ];
}
