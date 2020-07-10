import 'package:altar_of_prayers/models/edition.dart';
import 'package:altar_of_prayers/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class MakePaymentState extends Equatable {
  const MakePaymentState();

  @override
  List<Object> get props => [];
}

class PaymentLoading extends MakePaymentState {}

class ShowPaymentScreen extends MakePaymentState {
  final bool showLoadingDialog;

  ShowPaymentScreen({this.showLoadingDialog});
  @override
  List<Object> get props => [showLoadingDialog];
}

class PaymentSuccessful extends MakePaymentState {
  final Edition edition;

  const PaymentSuccessful({this.edition});
}

class PaymentFailed extends MakePaymentState {
  final String error;
  final String reference;
  final int editionId;
  const PaymentFailed({this.error, this.reference, this.editionId});
}

class LoadUserInfo extends MakePaymentState {
  final User user;

  LoadUserInfo({this.user});
}
