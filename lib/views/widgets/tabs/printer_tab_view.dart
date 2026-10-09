import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodels/providers.dart';
import '../../utils/ui_helpers.dart';

class PrinterTabView extends ConsumerWidget {
  final TextEditingController storeController;
  final TextEditingController orderController;
  final TextEditingController totalController;

  const PrinterTabView({
    super.key,
    required this.storeController,
    required this.orderController,
    required this.totalController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final senderState = ref.watch(senderProvider);
    final senderNotifier = ref.read(senderProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: storeController,
                  decoration: InputDecoration(
                    labelText: 'Store / Header',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: orderController,
                  decoration: InputDecoration(
                    labelText: 'Order #',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: totalController,
                  decoration: InputDecoration(
                    labelText: 'Total Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Cut Paper', style: TextStyle(fontSize: 12)),
                selected: senderState.cutPaper,
                onSelected: (val) {
                  senderNotifier.setCutPaper(val);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.text_fields, size: 16),
                  label: const Text(
                    'Print Simple Line',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: senderState.isSending
                      ? null
                      : () async {
                          final result =
                              await senderNotifier.printSimpleLine();
                          if (context.mounted) {
                            UiHelpers.showSnackbar(
                              context,
                              result.message,
                              isError: !result.isSuccess,
                            );
                          }
                        },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.content_cut, size: 16),
                  label: const Text(
                    'Cut Paper Only',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: senderState.isSending
                      ? null
                      : () async {
                          final result = await senderNotifier.cutPaperOnly();
                          if (context.mounted) {
                            UiHelpers.showSnackbar(
                              context,
                              result.message,
                              isError: !result.isSuccess,
                            );
                          }
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
