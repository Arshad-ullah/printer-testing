import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../viewmodels/providers.dart';
import '../../utils/ui_helpers.dart';

class PictureTabView extends ConsumerWidget {
  const PictureTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final senderState = ref.watch(senderProvider);
    final senderNotifier = ref.read(senderProvider.notifier);

    return Row(
      children: [
        Container(
          width: 110,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: senderState.selectedImageBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    senderState.selectedImageBytes!,
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 36,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 4),
                    const Text('No Image', style: TextStyle(fontSize: 11)),
                  ],
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.photo_library, size: 16),
                label: const Text('Pick Gallery'),
                onPressed: () async {
                  final result = await senderNotifier.pickImage(
                    ImageSource.gallery,
                  );
                  if (context.mounted && !result.isSuccess) {
                    UiHelpers.showSnackbar(
                      context,
                      result.message,
                      isError: true,
                    );
                  }
                },
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text('Take Photo'),
                onPressed: () async {
                  final result = await senderNotifier.pickImage(
                    ImageSource.camera,
                  );
                  if (context.mounted && !result.isSuccess) {
                    UiHelpers.showSnackbar(
                      context,
                      result.message,
                      isError: true,
                    );
                  }
                },
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                icon: const Icon(Icons.auto_awesome, size: 15),
                label: const Text(
                  'Use Sample Picture',
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  senderNotifier.loadSampleImage();
                  UiHelpers.showSnackbar(context, 'Sample test picture loaded!');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
