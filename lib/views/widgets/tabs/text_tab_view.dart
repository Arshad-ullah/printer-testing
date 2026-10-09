import 'package:flutter/material.dart';

class TextTabView extends StatelessWidget {
  final TextEditingController textController;

  const TextTabView({
    super.key,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Text Message / Custom Payload',
            hintText: 'Enter your message...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ActionChip(
              label: const Text('Quick Ping'),
              avatar: const Icon(Icons.flash_on, size: 16),
              onPressed: () {
                textController.text =
                    'Ping at ${TimeOfDay.now().format(context)}';
              },
            ),
            const SizedBox(width: 8),
            ActionChip(
              label: const Text('Order #1042'),
              avatar: const Icon(Icons.receipt, size: 16),
              onPressed: () {
                textController.text =
                    '{"orderId": 1042, "status": "CONFIRMED", "items": 3}';
              },
            ),
          ],
        ),
      ],
    );
  }
}
