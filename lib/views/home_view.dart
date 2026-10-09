import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/providers.dart';
import 'utils/ui_helpers.dart';
import 'widgets/device_info_card.dart';
import 'widgets/received_messages_section.dart';
import 'widgets/send_data_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wi-Fi / Hotspot Data & Printer',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Network IP',
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await ref.read(serverProvider.notifier).refreshNetwork();
              if (context.mounted) {
                UiHelpers.showSnackbar(context, 'Network refreshed');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            // Section 1: This Device Local IP & Receiver Status
            DeviceInfoCard(),
            SizedBox(height: 16),

            // Section 2: Send Dynamic Data (Text, Contact, QR, Picture, Thermal Printer)
            SendDataCard(),
            SizedBox(height: 16),

            // Section 3: Received Dynamic Data Log
            ReceivedMessagesSection(),
          ],
        ),
      ),
    );
  }
}
