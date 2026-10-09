import 'dart:convert';
import '../models/receipt_model.dart';

class EscPosService {
  List<int> buildReceipt(ReceiptModel receipt) {
    final List<int> bytes = [];

    // 1. Initialize Printer (ESC @)
    bytes.addAll([0x1B, 0x40]);

    // 2. Center alignment (ESC a 1)
    bytes.addAll([0x1B, 0x61, 0x01]);

    // 3. Double-height & double-width title (GS ! 0x11)
    bytes.addAll([0x1D, 0x21, 0x11]);
    bytes.addAll(utf8.encode('${receipt.storeName}\n'));

    // 4. Reset font size (GS ! 0x00)
    bytes.addAll([0x1D, 0x21, 0x00]);
    bytes.addAll(utf8.encode('*** WI-FI ORDER RECEIPT ***\n'));
    bytes.addAll(utf8.encode('--------------------------------\n'));

    // 5. Left alignment (ESC a 0)
    bytes.addAll([0x1B, 0x61, 0x00]);
    bytes.addAll(utf8.encode('Order ID:  ${receipt.orderNumber}\n'));
    bytes.addAll(utf8.encode('Customer:  ${receipt.customerName}\n'));
    if (receipt.phone.isNotEmpty) {
      bytes.addAll(utf8.encode('Phone:     ${receipt.phone}\n'));
    }
    bytes.addAll(
      utf8.encode('Date:      ${DateTime.now().toString().split('.')[0]}\n'),
    );
    bytes.addAll(utf8.encode('--------------------------------\n'));

    // Sample items table
    bytes.addAll(utf8.encode('1x Cappuccino             \$4.50\n'));
    bytes.addAll(utf8.encode('1x Almond Croissant       \$3.50\n'));
    bytes.addAll(utf8.encode('--------------------------------\n'));

    // Total section (Right align, Bold)
    bytes.addAll([0x1B, 0x61, 0x02]);
    bytes.addAll([0x1B, 0x45, 0x01]); // Bold ON
    bytes.addAll(utf8.encode('TOTAL: ${receipt.total}\n\n'));
    bytes.addAll([0x1B, 0x45, 0x00]); // Bold OFF

    // QR Code section (Center align)
    if (receipt.qrData.isNotEmpty) {
      bytes.addAll([0x1B, 0x61, 0x01]);
      bytes.addAll(utf8.encode('Scan to verify / pay:\n'));

      // ESC/POS QR Code configuration (Model 2)
      // Set QR module size to 6: [0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x43, n]
      bytes.addAll([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x43, 0x06]);
      // Set error correction level M (49): [0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, 49]
      bytes.addAll([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, 0x31]);

      // Store QR data into symbol storage area
      final qrBytes = utf8.encode(receipt.qrData);
      final pL = (qrBytes.length + 3) % 256;
      final pH = (qrBytes.length + 3) ~/ 256;
      bytes.addAll([0x1D, 0x28, 0x6B, pL, pH, 0x31, 0x50, 0x30]);
      bytes.addAll(qrBytes);

      // Print stored QR symbol
      bytes.addAll([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30]);
      bytes.addAll(utf8.encode('\n'));
    }

    // Center footer
    bytes.addAll([0x1B, 0x61, 0x01]);
    bytes.addAll(utf8.encode('Thank you for your business!\n'));

    // Feed lines so paper clears the cutter
    bytes.addAll([0x0A, 0x0A, 0x0A, 0x0A]);

    // Partial / Full paper cut (GS V 66 0)
    if (receipt.cut) {
      bytes.addAll([0x1D, 0x56, 0x42, 0x00]);
    }

    return bytes;
  }

  List<int> buildSimpleLine(String text) {
    return <int>[
      0x1B, 0x40, // Init
      ...utf8.encode('$text\n\n\n'),
      0x1D, 0x56, 0x42, 0x00, // Cut
    ];
  }

  List<int> buildPaperCut() {
    return <int>[
      0x0A, 0x0A, 0x0A,
      0x1D, 0x56, 0x42, 0x00, // Cut
    ];
  }
}
