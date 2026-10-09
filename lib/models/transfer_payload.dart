import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'data_type.dart';

class TransferPayload extends Equatable {
  final DataType type;
  final String title;
  final String payload; // text, json string, or base64 image data
  final Map<String, dynamic>? metadata;

  const TransferPayload({
    required this.type,
    required this.title,
    required this.payload,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'title': title,
    'payload': payload,
    'metadata': metadata,
    'timestamp': DateTime.now().toIso8601String(),
  };

  factory TransferPayload.fromJson(Map<String, dynamic> map) {
    return TransferPayload(
      type: DataType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => DataType.text,
      ),
      title: map['title'] ?? 'Data',
      payload: map['payload'] ?? '',
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  factory TransferPayload.fromRaw(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic> && decoded.containsKey('type')) {
        return TransferPayload.fromJson(decoded);
      }
    } catch (_) {}
    return TransferPayload(
      type: DataType.text,
      title: 'Plain Message',
      payload: raw,
    );
  }

  @override
  List<Object?> get props => [type, title, payload, metadata];
}
