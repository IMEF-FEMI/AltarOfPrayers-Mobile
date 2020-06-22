import 'package:equatable/equatable.dart';

abstract class MakePaymentEvent extends Equatable {
  const MakePaymentEvent();

  @override
  List<Object> get props => [];
}

class CheckForIncompleteTransactions extends MakePaymentEvent {
  final int editionId;
  final int startingMonth;
  final int year;

  CheckForIncompleteTransactions(
      {this.editionId, this.startingMonth, this.year});

  @override
  List<Object> get props => [editionId, startingMonth, year];
}

class CompleteTransaction extends MakePaymentEvent {
  final int editionId;
  final String reference;
  final String paidFor;

  const CompleteTransaction({this.paidFor, this.editionId, this.reference});
}
