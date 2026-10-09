import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/providers.dart';
import '../utils/ui_helpers.dart';

class DeviceInfoCard extends ConsumerWidget {
  const DeviceInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final serverState = ref.watch(serverProvider);

    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wifi_tethering,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'THIS PHONE (RECEIVER INFO)',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: serverState.isServerRunning
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: serverState.isServerRunning
                              ? Colors.green
                              : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        serverState.isServerRunning ? 'Listening' : 'Stopped',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: serverState.isServerRunning
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My IP Address (Share with other phone):',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        SelectableText(
                          serverState.myIp,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        if (serverState.allIps.length > 1) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Other IPs: ${serverState.allIps.skip(1).join(", ")}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy IP',
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: serverState.myIp.startsWith('1')
                        ? () => UiHelpers.copyToClipboard(
                              context,
                              serverState.myIp,
                            )
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Port: ${serverState.port} • Connect both devices to same Wi-Fi / Hotspot.',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (serverState.serverError != null) ...[
              const SizedBox(height: 6),
              Text(
                serverState.serverError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
