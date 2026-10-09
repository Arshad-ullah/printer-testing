import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/providers.dart';
import 'received_message_card.dart';

class ReceivedMessagesSection extends ConsumerWidget {
  const ReceivedMessagesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final serverState = ref.watch(serverProvider);
    final serverNotifier = ref.read(serverProvider.notifier);
    final messages = serverState.messages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Icon(Icons.inbox, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'RECEIVED DATA (${messages.length})',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            if (messages.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  serverNotifier.clearMessages();
                },
              ),
          ],
        ),
        const SizedBox(height: 8),

        // List or Empty placeholder
        if (messages.isEmpty)
          Container(
            height: 140,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phonelink_ring_outlined,
                  size: 36,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No messages or data received yet',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select Picture, QR Code, or Name and tap Send on other phone',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: messages.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return ReceivedMessageCard(message: messages[index]);
            },
          ),
      ],
    );
  }
}
