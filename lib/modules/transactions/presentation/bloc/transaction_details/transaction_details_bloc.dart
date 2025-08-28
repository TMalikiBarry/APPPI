import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/core/env.dart';

import '../../../../../core/api.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_error.dart';
import '../../../ports/input/transaction_input_port.dart';
import 'transaction_details_event.dart';
import 'transaction_details_state.dart';

class TransactionDetailsBloc
    extends Bloc<TransactionDetailsEvent, TransactionDetailsState> {
  //
  final logger = Logger();

  //
  final TransactionInputPort transactionInputPort;
  final Transaction transaction;

  TransactionDetailsBloc(this.transactionInputPort, this.transaction)
      : super(TransactionDetailsInitialState(transaction)) {
    // Pour recuperer les details d'une transaction
    on<TransactionDetailsFetchEvent>(_onTransactionDetailsFetchEvent);
    // Modifier la catégorie
    on<TransactionCategorieUpdateEvent>(_onTransactionCategorieUpdateEvent);

    // Retourner les fonds d'un transfert reçu
    on<TransactionReturnSendEvent>(_onTransactionReturnSendEvent);
    on<TransactionReturnResponseEvent>(_onTransactionReturnResponseEvent);

    // Demander l'annulation
    on<TransactionCancelSendEvent>(_onTransactionCancelSendEvent);

    // on<ChargerTicketDeCaisseEvent>(_onChargerTicketDeCaisseEvent);

    // on<ChangerCategorieEvent>(_onChangerCategorieEvent);
    // on<SupprimerTicketDeCaisseEvent>(_onSupprimerTicketDeCaisseEvent);
  }

  /// Pour Recuperer les infos sur la demande de paiement
  Future<void> _onTransactionDetailsFetchEvent(
    TransactionDetailsFetchEvent event,
    Emitter<TransactionDetailsState> emit,
  ) async {
    print("fetch details");
    try {
    Transaction tx = await transactionInputPort.get(transaction.guID ?? transaction.endToEndId);
    // //TODO remove before release
    // if (AppEnv.mode != "demo") {
      emit(TransactionDetailsInitialState(tx));
    // }
    } on ApiException catch (e) {
      emit(TransactionDetailsReturnState(
        transaction,
        TransactionError.unknow,
      ));
    }
  }

  /// Pour mettre à jour la catégorie de transaction
  Future<void> _onTransactionCategorieUpdateEvent(
    TransactionCategorieUpdateEvent event,
    Emitter<TransactionDetailsState> emit,
  ) async {
    Transaction tx = event.transaction;
    tx.categorie = event.categorie.id;
    await transactionInputPort.update(tx);
    emit(TransactionDetailsInitialState(tx));
  }

  /// Quand on confirme l'envoi du retour de fonds
  _onTransactionReturnSendEvent(
    TransactionReturnSendEvent event,
    Emitter<TransactionDetailsState> emit,
  ) async {
    Transaction tx = event.transaction;
    tx.retourDate = tx.dateOperation;
    emit(TransactionReturnLoadingState(tx));
    // return funds
    try {
      Stream<Transaction> stream = await transactionInputPort.returnFunds(tx);
      stream.listen(
        (trans) {
          add(TransactionReturnResponseEvent(trans));
        },
      );
    } on ApiException catch (e) {
      if (e.error == ApiError.forbidden &&
          e.problem != null &&
          e.problem!.invalidParams != null) {
        var badParam = e.problem!.invalidParams!["name"];
        if (badParam == "solde") {
          emit(TransactionDetailsReturnState(
            tx,
            TransactionError.soldeInsuffisant,
          ));
        } //
        else if (badParam == "date") {
          emit(TransactionDetailsReturnState(
            tx,
            TransactionError.delaiDepasse,
          ));
        } //
        else if (badParam == "statut") {
          emit(TransactionDetailsReturnState(
            tx,
            TransactionError.dejaRetourne,
          ));
        } else {
          emit(TransactionDetailsReturnState(
            tx,
            TransactionError.unknow,
          ));
        }
      } else {
        emit(TransactionDetailsReturnState(
          tx,
          TransactionError.unknow,
        ));
      }
    }
  }

  /// Quand on recoit la réponse d'un retour de fonds
  _onTransactionReturnResponseEvent(
    TransactionReturnResponseEvent event,
    Emitter<TransactionDetailsState> emit,
  ) {
    Transaction tx = event.transaction;
    //emit(TransactionReturnLoadingState(tx));
    if (tx.retourDate != null) {
      emit(TransactionDetailsReturnState(tx, null));
    } else {
      // C'est rejeté => "Le participant payeur (destinataire) n'est pas actif"
      if (tx.retourStatutRaison == "AG10") {
        emit(TransactionDetailsReturnState(
          tx,
          TransactionError.destinataireIndisponible,
        ));
      }
      //
      else {
        emit(TransactionDetailsReturnState(
          tx,
          TransactionError.unknow,
        ));
      }
    }
  }

  /// Quand on confirme l'envoi de la demande d'annulation
  _onTransactionCancelSendEvent(
    TransactionCancelSendEvent event,
    Emitter<TransactionDetailsState> emit,
  ) async {
    Transaction tx = event.transaction;
    emit(TransactionDetailsCancelLoadingState(tx));
    try {
      tx = await transactionInputPort.cancel(tx, event.reason);
      emit(TransactionDetailsCancelState(tx, null));
    } catch (e) {
      logger.e("Erreur à l'envoi de la demande d'annulation", error: e);
      emit(TransactionDetailsCancelState(tx, TransactionError.unknow));
    }
  }

  // void _onRecuperationTransactionDetailsEvent(
  //   RecuperationTransactionDetailsEvent event,
  //   Emitter<TransactionDetailsState> emit,
  // ) async {
  //   try {
  //     emit(TransactionDetailsLoadingState());
  //     Transaction transaction =
  //     await transactionInputPort.getTransactionLocally(event.transactionId);
  //     emit(TransactionDetailsSuccessState(transaction));
  //   } catch (e) {
  //     emit(TransactionDetailsErrorState(e.toString()));
  //   }
  // }

  // void _onChargerTicketDeCaisseEvent(
  //   ChargerTicketDeCaisseEvent event,
  //   Emitter<TransactionDetailsState> emit,
  // ) async {
  //   try {
  //     String? imagePath =
  //    await transactionInputPort.saveTicketDeCaisseToDevice(
  //         file: File(event.filePath), transactionId: event.transactionId);
  //     if (imagePath == null) {
  //       emit(LoadTicketErrorState("Erreur pendant le chargement du ticket"));
  //     } else {
  //       emit(LoadTicketSuccessState(imagePath));
  //     }
  //   } catch (e) {
  //     emit(LoadTicketErrorState("Erreur pendant le chargement du ticket"));
  //   }
  // }

  // void _onChangerCategorieEvent(
  //   ChangerCategorieEvent event,
  //   Emitter<TransactionDetailsState> emit,
  // ) async {
  //   try {
  //     await transactionInputPort.saveCategorieToTransaction(
  //         categorie: event.categorie, transactionId: event.transactionId);
  //     emit(AddCategorieSuccessState(event.categorie));
  //   } catch (e) {
  //     emit(AddCategorieErrorState(
  //         "Erreur pendant la mise a jour de la catégorie"));
  //   }
  // }

  // void _onSupprimerTicketDeCaisseEvent(
  //   SupprimerTicketDeCaisseEvent event,
  //   Emitter<TransactionDetailsState> emit,
  // ) async {
  //   try {
  //     await transactionInputPort.deleteTicketDeCaisseFromDevice(
  //         transactionId: event.transactionId);
  //     emit(DeleteTicketSuccessState());
  //   } catch (e) {
  //     emit(DeleteTicketErrorState(
  //         "Erreur pendant la mise a jour de la catégorie"));
  //   }
  // }
}
