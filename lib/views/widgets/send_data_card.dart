import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/action_result.dart';
import '../../viewmodels/providers.dart';
import '../../viewmodels/sender_state.dart';
import '../utils/ui_helpers.dart';
import 'tabs/contact_tab_view.dart';
import 'tabs/picture_tab_view.dart';
import 'tabs/printer_tab_view.dart';
import 'tabs/qr_tab_view.dart';
import 'tabs/text_tab_view.dart';

class SendDataCard extends ConsumerStatefulWidget {
  const SendDataCard({super.key});

  @override
  ConsumerState<SendDataCard> createState() => _SendDataCardState();
}

class _SendDataCardState extends ConsumerState<SendDataCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _targetIpController = TextEditingController();
  final TextEditingController _portController = TextEditingController(
    text: SenderState.defaultPort.toString(),
  );

  // Tab controllers
  final TextEditingController _textController = TextEditingController(
    text: 'Hello from another phone! 📱',
  );
  final TextEditingController _nameController = TextEditingController(
    text: 'Alex Morgan',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+1 555-0199',
  );
  final TextEditingController _roleController = TextEditingController(
    text: 'Software Engineer',
  );
  final TextEditingController _qrDataController = TextEditingController(
    text: 'https://flutter.dev',
  );

  final TextEditingController _printerStoreController = TextEditingController(
    text: 'SMART CAFE & BAKERY',
  );
  final TextEditingController _printerOrderController = TextEditingController(
    text: '#1089',
  );
  final TextEditingController _printerTotalController = TextEditingController(
    text: '\$8.00',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabChange);

    _targetIpController.addListener(() {
      ref.read(senderProvider.notifier).setTargetIp(_targetIpController.text);
    });

    _portController.addListener(() {
      final port = int.tryParse(_portController.text);
      if (port != null) {
        ref.read(senderProvider.notifier).setPort(port);
      }
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    ref.read(senderProvider.notifier).setActiveTab(_tabController.index);
    final currentSenderState = ref.read(senderProvider);
    _portController.text = currentSenderState.port.toString();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _targetIpController.dispose();
    _portController.dispose();
    _textController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _qrDataController.dispose();
    _printerStoreController.dispose();
    _printerOrderController.dispose();
    _printerTotalController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final senderNotifier = ref.read(senderProvider.notifier);
    ActionResult result;

    switch (_tabController.index) {
      case 0:
        result = await senderNotifier.sendText(_textController.text);
        break;
      case 1:
        result = await senderNotifier.sendContact(
          name: _nameController.text,
          phone: _phoneController.text,
          role: _roleController.text,
        );
        break;
      case 2:
        result = await senderNotifier.sendQr(_qrDataController.text);
        break;
      case 3:
        result = await senderNotifier.sendImage();
        break;
      case 4:
        result = await senderNotifier.printReceipt(
          storeName: _printerStoreController.text,
          customerName: _nameController.text,
          phone: _phoneController.text,
          orderNumber: _printerOrderController.text,
          total: _printerTotalController.text,
          qrData: _qrDataController.text,
        );
        break;
      default:
        return;
    }

    if (mounted) {
      UiHelpers.showSnackbar(
        context,
        result.message,
        isError: !result.isSuccess,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final senderState = ref.watch(senderProvider);
    final isPrinterMode = senderState.isPrinterTab;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPrinterMode ? Icons.print : Icons.send_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isPrinterMode
                      ? 'SEND TO THERMAL PRINTER (ESC/POS)'
                      : 'SEND DYNAMIC DATA',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Target IP and Port fields
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _targetIpController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: isPrinterMode ? 'Printer IP' : 'Target IP',
                      hintText: isPrinterMode
                          ? 'e.g. 192.168.1.200'
                          : 'e.g. 192.168.1.15',
                      prefixIcon: Icon(
                        isPrinterMode ? Icons.print : Icons.computer,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _portController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Port',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Quick Port selection chips
            Row(
              children: [
                const Text(
                  'Quick Port:',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  label: const Text(
                    'Phone (4040)',
                    style: TextStyle(fontSize: 11),
                  ),
                  onPressed: () {
                    _portController.text = SenderState.defaultPort.toString();
                    ref
                        .read(senderProvider.notifier)
                        .setPort(SenderState.defaultPort);
                  },
                ),
                const SizedBox(width: 6),
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  avatar: const Icon(Icons.print, size: 14),
                  label: const Text(
                    'Printer (9100)',
                    style: TextStyle(fontSize: 11),
                  ),
                  onPressed: () {
                    _portController.text = SenderState.printerPort.toString();
                    ref
                        .read(senderProvider.notifier)
                        .setPort(SenderState.printerPort);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Data Type Tabs (5 tabs)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                tabs: const [
                  Tab(icon: Icon(Icons.notes, size: 18), text: 'Text'),
                  Tab(icon: Icon(Icons.person, size: 18), text: 'Name'),
                  Tab(icon: Icon(Icons.qr_code, size: 18), text: 'QR Code'),
                  Tab(icon: Icon(Icons.image, size: 18), text: 'Picture'),
                  Tab(icon: Icon(Icons.print, size: 18), text: '🖨️ Printer'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tab View Contents
            SizedBox(
              height: 200,
              child: TabBarView(
                controller: _tabController,
                children: [
                  TextTabView(textController: _textController),
                  ContactTabView(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    roleController: _roleController,
                  ),
                  QrTabView(qrDataController: _qrDataController),
                  const PictureTabView(),
                  PrinterTabView(
                    storeController: _printerStoreController,
                    orderController: _printerOrderController,
                    totalController: _printerTotalController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Direct Send / Print Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                icon: senderState.isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(isPrinterMode ? Icons.print : Icons.send),
                label: Text(
                  senderState.isSending
                      ? (isPrinterMode ? 'Printing...' : 'Sending Data...')
                      : (isPrinterMode
                            ? 'PRINT RECEIPT DIRECTLY (PORT 9100)'
                            : 'SEND TO OTHER PHONE DIRECTLY'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: senderState.isSending ? null : _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
