import 'package:equatable/equatable.dart';
import 'transfer_payload.dart';

class ReceivedMessage extends Equatable {
  final String senderIp;
  final TransferPayload payload;
  final DateTime receivedAt;

  const ReceivedMessage({
    required this.senderIp,
    required this.payload,
    required this.receivedAt,
  });

  @override
  List<Object?> get props => [senderIp, payload, receivedAt];
}
