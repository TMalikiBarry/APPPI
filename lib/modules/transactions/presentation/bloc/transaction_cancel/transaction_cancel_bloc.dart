import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../core/api.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_error.dart';
import '../../../domain/models/transaction_reject_reason.dart';
import '../../../ports/input/transaction_input_port.dart';
import 'transaction_cancel_event.dart';
import 'transaction_cancel_state.dart';

class TransactionCancelBloc
    extends Bloc<TransactionCancelEvent, TransactionCancelState> {
  //
  final logger = Logger();

  //
  final TransactionInputPort transactionInputPort;
  final String endToEndId;

  TransactionCancelBloc(this.transactionInputPort, this.endToEndId)
      : super(TransactionCancelInitialState(endToEndId)) {
    // Pour recuperer une demande d'annulation
    on<TransactionCancelFetchEvent>(_onTransactionCancelFetchEvent);

    // Pour accepter une demande d'annulation
    on<TransactionCancelAcceptEvent>(_onTransactionCancelAcceptEvent);
    on<TransactionCancelAcceptResponseEvent>(
        _onTransactionCancelAcceptResponseEvent);

    // Pour rejeter une demande d'annulation
    on<TransactionCancelRejectEvent>(_onTransactionCancelRejectEvent);
  }

  /// Pour Recuperer les infos sur la demande d'annulation
  Future<void> _onTransactionCancelFetchEvent(
    TransactionCancelFetchEvent event,
    Emitter<TransactionCancelState> emit,
  ) async {
    Transaction tx = await transactionInputPort.get(endToEndId);
    emit(TransactionCancelDetailsState(endToEndId, tx));
  }

  /// Pour rejeter la demande d'annulation
  Future<void> _onTransactionCancelRejectEvent(
    TransactionCancelRejectEvent event,
    Emitter<TransactionCancelState> emit,
  ) async {
    Transaction tx = event.transaction;
    emit(TransactionCancelLoadingState(tx.endToEndId, tx));
    try {
      tx = await transactionInputPort.reject(tx, TransactionRejectReason.autre);
      emit(TransactionCancelReponseState(tx.endToEndId, tx));
    }
    // Erreurs
    on ApiException catch (e) {
      if (e.error == ApiError.forbidden &&
          e.problem != null &&
          e.problem!.invalidParams != null) {
        var badParam = e.problem!.invalidParams!["name"];
        if (badParam == "date") {
          emit(TransactionCancelReponseState(
            tx.endToEndId,
            tx,
            TransactionError.delaiDepasse,
          ));
        } //
        else if (badParam == "statut") {
          emit(TransactionCancelReponseState(
            tx.endToEndId,
            tx,
            TransactionError.dejaRetourne,
          ));
        } else {
          emit(TransactionCancelReponseState(
            tx.endToEndId,
            tx,
            TransactionError.unknow,
          ));
        }
      } else {
        emit(TransactionCancelReponseState(
          tx.endToEndId,
          tx,
          TransactionError.unknow,
        ));
      }
    }
  }

  // Pour Accepter la demande d'annulation
  Future<void> _onTransactionCancelAcceptEvent(
    TransactionCancelAcceptEvent event,
    Emitter<TransactionCancelState> emit,
  ) async {
    emit(TransactionCancelLoadingState(event.endToEndId, event.transaction));
    Transaction tx = event.transaction;
    try {
      // return funds
      Stream<Transaction> stream = await transactionInputPort.returnFunds(
        tx,
      );
      stream.listen(
        (trans) {
          add(TransactionCancelAcceptResponseEvent(trans));
        },
      );
    } on ApiException catch (e) {
      if (e.error == ApiError.forbidden &&
          e.problem != null &&
          e.problem!.invalidParams != null) {
        var badParam = e.problem!.invalidParams!["name"];
        if (badParam == "solde") {
          emit(TransactionCancelReponseState(
            tx.endToEndId,
            tx,
            TransactionError.soldeInsuffisant,
          ));
        } //
        else if (badParam == "date") {
          emit(TransactionCancelReponseState(
            tx.endToEndId,
            tx,
            TransactionError.delaiDepasse,
          ));
        } //
        else if (badParam == "statut") {
          emit(TransactionCancelReponseState(
            tx.endToEndId,
            tx,
            TransactionError.dejaRetourne,
          ));
        }
      } else {
        emit(TransactionCancelReponseState(
          tx.endToEndId,
          tx,
          TransactionError.unknow,
        ));
      }
    }
  }

  /// Quand on recoit la réponse au retour de fonds
  _onTransactionCancelAcceptResponseEvent(
    TransactionCancelAcceptResponseEvent event,
    Emitter<TransactionCancelState> emit,
  ) {
    Transaction tx = event.transaction;
    if (tx.retourStatutRaison != null) {
      // C'est rejeté => "Le participant payeur (destinataire) n'est pas actif"
      if (tx.retourStatutRaison == "AG10") {
        emit(TransactionCancelReponseState(
          tx.endToEndId,
          tx,
          TransactionError.destinataireIndisponible,
        ));
      }
      //
      else {
        emit(TransactionCancelReponseState(
          tx.endToEndId,
          tx,
          TransactionError.unknow,
        ));
      }
    }
    //
    else {
      emit(TransactionCancelReponseState(tx.endToEndId, tx));
    }
  }
}
