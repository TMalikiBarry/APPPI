import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_error.dart';

abstract class TransactionDetailsState {
  final Transaction transaction;
  const TransactionDetailsState(this.transaction);
}

class TransactionDetailsInitialState extends TransactionDetailsState {
  const TransactionDetailsInitialState(super.transaction);
}

class TransactionDetailsReturnState extends TransactionDetailsState {
  final TransactionError? error;
  const TransactionDetailsReturnState(super.transaction, this.error);
}

class TransactionDetailsCancelState extends TransactionDetailsState {
  final TransactionError? error;
  const TransactionDetailsCancelState(super.transaction, this.error);
}

class TransactionDetailsCancelLoadingState extends TransactionDetailsState {
  TransactionDetailsCancelLoadingState(super.transaction);
}

// class TransactionDetailsLoadingState extends TransactionDetailsState {
//   const TransactionDetailsLoadingState(super.transaction);
// }

// class TransactionDetailsErrorState extends TransactionDetailsState {
//   final String errorMessage;
//   const TransactionDetailsErrorState(super.transaction, this.errorMessage);
// }

// class LoadTicketSuccessState extends TransactionDetailsState {
//   final String imagePath;
//   const LoadTicketSuccessState(super.transaction, this.imagePath);
// }

// class LoadTicketErrorState extends TransactionDetailsState {
//   final String errorMessage;
//   const LoadTicketErrorState(super.transaction, this.errorMessage);
// }

// class AddCategorieSuccessState extends TransactionDetailsState {
//   final String categorie;
//   const AddCategorieSuccessState(super.transaction, this.categorie);
// }

// class AddCategorieErrorState extends TransactionDetailsState {
//   final String errorMessage;
//   const AddCategorieErrorState(super.transaction, this.errorMessage);
// }

// class DeleteTicketSuccessState extends TransactionDetailsState {
//   const DeleteTicketSuccessState(super.transaction);
// }

// class DeleteTicketErrorState extends TransactionDetailsState {
//   final String errorMessage;
//   DeleteTicketErrorState(super.transaction, this.errorMessage);
// }
