import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/data_type.dart';
import '../../models/received_message.dart';
import '../../models/transfer_payload.dart';
import '../utils/ui_helpers.dart';

class ReceivedMessageCard extends StatelessWidget {
  final ReceivedMessage message;

  const ReceivedMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStr =
        '${message.receivedAt.hour.toString().padLeft(2, '0')}:${message.receivedAt.minute.toString().padLeft(2, '0')}:${message.receivedAt.second.toString().padLeft(2, '0')}';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Type Tag and Sender IP
            Row(
              children: [
                _buildTypeBadge(message.payload.type),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'From ${message.senderIp}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Dynamic Body based on type
            _buildPayloadView(context, message.payload, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(DataType type) {
    IconData icon;
    String label;
    Color color;

    switch (type) {
      case DataType.text:
        icon = Icons.notes;
        label = 'Text';
        color = Colors.blue;
        break;
      case DataType.name:
        icon = Icons.person;
        label = 'Contact';
        color = Colors.green;
        break;
      case DataType.qrcode:
        icon = Icons.qr_code;
        label = 'QR Code';
        color = Colors.purple;
        break;
      case DataType.picture:
        icon = Icons.image;
        label = 'Picture';
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayloadView(
    BuildContext context,
    TransferPayload payload,
    ThemeData theme,
  ) {
    switch (payload.type) {
      case DataType.text:
        return SelectableText(
          payload.payload,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        );

      case DataType.name:
        Map<String, dynamic> data = payload.metadata ?? {};
        if (data.isEmpty) {
          try {
            data = jsonDecode(payload.payload);
          } catch (_) {}
        }
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.shade200,
                radius: 24,
                child: Text(
                  (data['name'] ?? 'U')
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'] ?? 'Unknown Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (data['role'] != null &&
                        data['role'].toString().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        data['role'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                    if (data['phone'] != null &&
                        data['phone'].toString().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 13,
                            color: Colors.green.shade800,
                          ),
                          const SizedBox(width: 4),
                          SelectableText(
                            data['phone'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );

      case DataType.qrcode:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.purple.shade100),
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: QrImageView(
                  data: payload.payload,
                  version: QrVersions.auto,
                  size: 90,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scannable QR Code',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      payload.payload,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      icon: const Icon(Icons.copy, size: 14),
                      label: const Text(
                        'Copy Content',
                        style: TextStyle(fontSize: 11),
                      ),
                      onPressed: () =>
                          UiHelpers.copyToClipboard(context, payload.payload),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case DataType.picture:
        try {
          final imageBytes = base64Decode(payload.payload);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.memory(imageBytes),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    imageBytes,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    payload.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Tap image to view full size',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          );
        } catch (e) {
          return Text('Failed to load image: $e');
        }
    }
  }
}
