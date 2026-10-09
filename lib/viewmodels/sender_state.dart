import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class SenderState extends Equatable {
  static const int defaultPort = 4040;
  static const int printerPort = 9100;

  final String targetIp;
  final int port;
  final int activeTabIndex;
  final bool isSending;
  final Uint8List? selectedImageBytes;
  final String? selectedImageName;
  final bool cutPaper;

  const SenderState({
    this.targetIp = '',
    this.port = defaultPort,
    this.activeTabIndex = 0,
    this.isSending = false,
    this.selectedImageBytes,
    this.selectedImageName,
    this.cutPaper = true,
  });

  bool get isPrinterTab => activeTabIndex == 4;

  SenderState copyWith({
    String? targetIp,
    int? port,
    int? activeTabIndex,
    bool? isSending,
    Uint8List? selectedImageBytes,
    bool clearImage = false,
    String? selectedImageName,
    bool? cutPaper,
  }) {
    return SenderState(
      targetIp: targetIp ?? this.targetIp,
      port: port ?? this.port,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      isSending: isSending ?? this.isSending,
      selectedImageBytes: clearImage
          ? null
          : (selectedImageBytes ?? this.selectedImageBytes),
      selectedImageName: clearImage
          ? null
          : (selectedImageName ?? this.selectedImageName),
      cutPaper: cutPaper ?? this.cutPaper,
    );
  }

  @override
  List<Object?> get props => [
    targetIp,
    port,
    activeTabIndex,
    isSending,
    selectedImageBytes,
    selectedImageName,
    cutPaper,
  ];
}
