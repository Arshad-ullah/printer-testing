import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrTabView extends StatefulWidget {
  final TextEditingController qrDataController;

  const QrTabView({
    super.key,
    required this.qrDataController,
  });

  @override
  State<QrTabView> createState() => _QrTabViewState();
}

class _QrTabViewState extends State<QrTabView> {
  @override
  void initState() {
    super.initState();
    widget.qrDataController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.qrDataController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.qrDataController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'QR Code Data / URL',
                  hintText: 'https://...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Receiver phone will render this as a scannable QR Code image.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: widget.qrDataController.text.isNotEmpty
              ? QrImageView(
                  data: widget.qrDataController.text,
                  version: QrVersions.auto,
                  size: 80,
                )
              : const Icon(Icons.qr_code, size: 40, color: Colors.grey),
        ),
      ],
    );
  }
}
