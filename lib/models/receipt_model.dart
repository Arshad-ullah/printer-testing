import 'package:equatable/equatable.dart';

class ReceiptModel extends Equatable {
  final String storeName;
  final String customerName;
  final String phone;
  final String orderNumber;
  final String total;
  final String qrData;
  final bool cut;

  const ReceiptModel({
    required this.storeName,
    required this.customerName,
    required this.phone,
    required this.orderNumber,
    required this.total,
    required this.qrData,
    this.cut = true,
  });

  @override
  List<Object?> get props => [
    storeName,
    customerName,
    phone,
    orderNumber,
    total,
    qrData,
    cut,
  ];
}
