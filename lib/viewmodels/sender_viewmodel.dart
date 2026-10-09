import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/data_type.dart';
import '../models/receipt_model.dart';
import '../models/transfer_payload.dart';
import '../services/escpos_service.dart';
import '../services/image_picker_service.dart';
import '../services/socket_client_service.dart';
import 'action_result.dart';
import 'providers.dart';
import 'sender_state.dart';

class SenderViewModel extends Notifier<SenderState> {
  @override
  SenderState build() {
    return const SenderState();
  }

  SocketClientService get _socketClient => ref.read(socketClientServiceProvider);
  EscPosService get _escPosService => ref.read(escPosServiceProvider);
  ImagePickerService get _imagePickerService =>
      ref.read(imagePickerServiceProvider);

  void setTargetIp(String ip) {
    state = state.copyWith(targetIp: ip.trim());
  }

  void setPort(int port) {
    state = state.copyWith(port: port);
  }

  void setActiveTab(int index) {
    int newPort = state.port;
    if (index == 4) {
      if (state.port == SenderState.defaultPort) {
        newPort = SenderState.printerPort;
      }
    } else {
      if (state.port == SenderState.printerPort) {
        newPort = SenderState.defaultPort;
      }
    }
    state = state.copyWith(
      activeTabIndex: index,
      port: newPort,
    );
  }

  void setCutPaper(bool cut) {
    state = state.copyWith(cutPaper: cut);
  }

  Future<ActionResult> pickImage(ImageSource source) async {
    try {
      final picked = await _imagePickerService.pickImage(source);
      if (picked != null) {
        state = state.copyWith(
          selectedImageBytes: picked.bytes,
          selectedImageName: picked.name,
        );
        return const ActionResult.success('Image selected');
      }
      return const ActionResult.failure('No image selected');
    } catch (e) {
      return ActionResult.failure('Could not load image: $e');
    }
  }

  void loadSampleImage() {
    final sample = _imagePickerService.getSampleImage();
    state = state.copyWith(
      selectedImageBytes: sample.bytes,
      selectedImageName: sample.name,
    );
  }

  void clearImage() {
    state = state.copyWith(clearImage: true);
  }

  Future<ActionResult> sendText(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return const ActionResult.failure('Please enter text to send');
    }
    return _sendPayload(
      TransferPayload(
        type: DataType.text,
        title: 'Text Message',
        payload: trimmed,
      ),
    );
  }

  Future<ActionResult> sendContact({
    required String name,
    required String phone,
    required String role,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const ActionResult.failure('Please enter a name');
    }
    final contactData = {
      'name': trimmedName,
      'phone': phone.trim(),
      'role': role.trim(),
    };
    return _sendPayload(
      TransferPayload(
        type: DataType.name,
        title: 'Contact ($trimmedName)',
        payload: jsonEncode(contactData),
        metadata: contactData,
      ),
    );
  }

  Future<ActionResult> sendQr(String qrData) async {
    final trimmed = qrData.trim();
    if (trimmed.isEmpty) {
      return const ActionResult.failure('Please enter QR code content');
    }
    return _sendPayload(
      TransferPayload(
        type: DataType.qrcode,
        title: 'QR Code',
        payload: trimmed,
      ),
    );
  }

  Future<ActionResult> sendImage() async {
    if (state.selectedImageBytes == null) {
      return const ActionResult.failure('Please select or generate a picture first');
    }
    final base64Image = base64Encode(state.selectedImageBytes!);
    return _sendPayload(
      TransferPayload(
        type: DataType.picture,
        title: state.selectedImageName ?? 'Picture',
        payload: base64Image,
        metadata: {'sizeBytes': state.selectedImageBytes!.length},
      ),
    );
  }

  Future<ActionResult> printReceipt({
    required String storeName,
    required String customerName,
    required String phone,
    required String orderNumber,
    required String total,
    required String qrData,
  }) async {
    final receipt = ReceiptModel(
      storeName: storeName.trim().isEmpty ? 'STORE' : storeName.trim(),
      customerName: customerName.trim().isEmpty ? 'Guest' : customerName.trim(),
      phone: phone.trim(),
      orderNumber: orderNumber.trim(),
      total: total.trim(),
      qrData: qrData.trim(),
      cut: state.cutPaper,
    );
    final bytes = _escPosService.buildReceipt(receipt);
    return _sendRawBytesToPrinter(bytes, title: 'Thermal Receipt');
  }

  Future<ActionResult> printSimpleLine([String text = 'Hello Wi-Fi Printer!\nTest successful!']) async {
    final bytes = _escPosService.buildSimpleLine(text);
    return _sendRawBytesToPrinter(bytes, title: 'Test Line');
  }

  Future<ActionResult> cutPaperOnly() async {
    final bytes = _escPosService.buildPaperCut();
    return _sendRawBytesToPrinter(bytes, title: 'Cut Command');
  }

  Future<ActionResult> _sendPayload(TransferPayload payload) async {
    final targetIp = state.targetIp.trim();
    final port = state.port;

    if (targetIp.isEmpty) {
      return const ActionResult.failure('Please enter target device IP address');
    }

    state = state.copyWith(isSending: true);
    try {
      await _socketClient.sendPayload(
        targetIp: targetIp,
        port: port,
        payload: payload,
      );
      return ActionResult.success('✓ Sent ${payload.title} to $targetIp:$port!');
    } on SocketException catch (e) {
      return ActionResult.failure(
        'Failed to connect to $targetIp:$port. Check Wi-Fi.\n(${e.message})',
      );
    } on TimeoutException {
      return const ActionResult.failure('Connection timed out. Check IP.');
    } catch (e) {
      return ActionResult.failure('Send error: $e');
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  Future<ActionResult> _sendRawBytesToPrinter(
    List<int> bytes, {
    String title = 'Receipt',
  }) async {
    final targetIp = state.targetIp.trim();
    final port = state.port;

    if (targetIp.isEmpty) {
      return const ActionResult.failure('Please enter Printer IP address');
    }

    state = state.copyWith(isSending: true);
    try {
      await _socketClient.sendRawBytes(
        targetIp: targetIp,
        port: port,
        bytes: bytes,
      );
      return ActionResult.success('✓ $title sent to Printer at $targetIp:$port!');
    } on SocketException catch (e) {
      return ActionResult.failure(
        'Printer connection failed ($targetIp:$port).\nCheck IP or port 9100.\n(${e.message})',
      );
    } on TimeoutException {
      return ActionResult.failure(
        'Printer timed out at $targetIp:$port. Check Wi-Fi & IP.',
      );
    } catch (e) {
      return ActionResult.failure('Print error: $e');
    } finally {
      state = state.copyWith(isSending: false);
    }
  }
}
