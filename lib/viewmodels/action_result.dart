import 'package:equatable/equatable.dart';

class ActionResult extends Equatable {
  final bool isSuccess;
  final String message;

  const ActionResult.success(this.message) : isSuccess = true;
  const ActionResult.failure(this.message) : isSuccess = false;

  @override
  List<Object?> get props => [isSuccess, message];
}
