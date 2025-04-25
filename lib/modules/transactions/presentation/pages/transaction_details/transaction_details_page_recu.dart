import 'dart:io';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme.dart';
import '../../../domain/models/transaction.dart';

class TransactionDetailsPageRecu extends StatelessWidget {

  const TransactionDetailsPageRecu({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    // Initialize locale based on user's preference
    final String locale = Localizations.localeOf(context).toString();
    // Format without decimals
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: 'FCFA ',
      decimalDigits: 0,
    );

    final rapportSmallTitle = Theme.of(context).textTheme.headlineSmall!
      .copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 15
    );
    final rapportSubTitle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 14
    );

    AppLocalizations traductions = AppLocalizations.of(context)!;

    final GlobalKey globalKey = GlobalKey();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.2,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            const SizedBox(height: 10,),
            // Boutton retour et partager
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Boutton retour 
                Expanded(child: Container()),
                // Boutton partager
                IconButton(
                  onPressed: () async{ 
                    await _createPDFAndShare(
                      globalKey,
                      traductions,
                      transaction
                    );
                  },
                  icon: Icon(
                    Platform.isIOS ? 
                    Icons.ios_share : 
                    Icons.share_rounded,
                  ),
                ),
              ],
            ),
            //
            const SizedBox(height: 20,),
            //
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: RepaintBoundary(
                        key: globalKey,
                        child: _recuDetails(
                          context, 
                          traductions, 
                          transaction,
                          currency: currency, 
                          rapportSmallTitle: rapportSmallTitle, 
                          rapportSubTitle: rapportSubTitle
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recuDetails(
    BuildContext context, 
    AppLocalizations traductions,
    Transaction transaction,{
    required NumberFormat currency,
    required TextStyle rapportSmallTitle,
    required TextStyle rapportSubTitle
  }){
    String locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: 
      CrossAxisAlignment.start,
      children: [
        // TItle
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(
            vertical: 25.0,),
          decoration: BoxDecoration(
            borderRadius: 
              BorderRadius.circular(8),
            color: Themer.brownColor,
          ),
          child: Center(
            child: Text(traductions.
              transactionDetailsRecuTitle,
              style: Theme.of(context).textTheme
                .titleSmall!.copyWith(
                color: Themer.whiteColor,
                fontSize: 25,
                fontWeight: FontWeight.w900
              )
            ),
          ),
        ),
  
        const SizedBox(height: 10),
  
        _recuItem(
          context,
          traductions.transactionDetailsRecuInfoIdentifiant, 
          data : transaction.endToEndId,
          rapportSmallTitle: rapportSmallTitle,
          rapportSubTitle: rapportSubTitle
        ),
        //
        const SizedBox(height: 10,),
                              
        // Référence
        if(transaction.txId != null)...[
          _recuItem(
            context,
            traductions.transactionDetailsRecuInfoReference, 
            data : transaction.txId!,
            rapportSmallTitle: rapportSmallTitle,
            rapportSubTitle: rapportSubTitle
          ),
          //
          const SizedBox(height: 10,),
        ],
                              
        // Montant
        _recuItem(
          context, traductions.transactionDetailsRecuInfoMontant,
          data: currency.format(transaction.montant.abs()),
          rapportSmallTitle: rapportSmallTitle,
          rapportSubTitle: rapportSubTitle
        ),
        //
        const SizedBox(height: 10,),

        // Frais
        _recuItem(
          context, traductions.transactionDetailsRecuInfoFrais,
          data: transaction.montantFrais != null 
            ? currency.format(transaction.montantFrais!)
            : traductions.transactionDetailsRecuInfoFraisDefault,
          rapportSmallTitle: rapportSmallTitle,
          rapportSubTitle: rapportSubTitle
        ),
        //
        const SizedBox(height: 10,),
                              
        // Emetteur/ Recepteur
        _recuItem(
          context, transaction.sens == TransactionSens.credit 
          ? traductions.transactionDetailsRecuInfoPayeurLabel 
          : traductions.transactionDetailsRecuInfoPayeLabel, 
          data : transaction.clientNom,
          rapportSmallTitle: rapportSmallTitle,
          rapportSubTitle: rapportSubTitle
        ),
        //
        const SizedBox(height: 10,),
                              
        // identifiant de l' Emetteur/ Recepteur
        _recuItem(
          context,
          transaction.clientAlias != null 
          ? traductions.transactionDetailsRecuInfoClientAlias 
          : traductions.transactionDetailsRecuInfoClientCompte, 
          data : (transaction.clientAlias ?? transaction.clientCompte)!,
          rapportSmallTitle: rapportSmallTitle,
          rapportSubTitle: rapportSubTitle
        ),
        //
        const SizedBox(height: 10,),
                              
        // institution
        if(transaction.clientCompte != null 
          && transaction.clientPSPNom != null)...[
          _recuItem(
            context, 
            traductions.transactionDetailsRecuInfoClientInstitution,
            data : transaction.clientPSPNom!,
            rapportSmallTitle: rapportSmallTitle,
            rapportSubTitle: rapportSubTitle
          ),
          //
          const SizedBox(height: 10,),
        ],
                              
        // Date Envoi / Reception
        _recuItem(
          context, transaction.sens == TransactionSens.credit 
          ? traductions.transactionDetailsRecuInfoDateReception 
          : traductions.transactionDetailsRecuInfoDateEnvoi, 
          data: DateFormat(
            'd/MM/yy, HH:mm',
            locale
          ).format(transaction.dateOperation!),
          rapportSmallTitle: rapportSmallTitle,
          rapportSubTitle: rapportSubTitle
        ),
        //
        const SizedBox(height: 10,),
      ],
    );
  }

  Widget _recuItem(
    BuildContext context, 
    String title, 
    {required String data,
    required TextStyle rapportSmallTitle,
    required TextStyle rapportSubTitle,}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: rapportSubTitle,
        ),
        Text(
          data,
          style: rapportSmallTitle,
        ),
      ],
    );
  }

  _createPDFAndShare (
    GlobalKey globalKey,
    AppLocalizations traductions,
    Transaction transaction) async {
    // Capture widget as image
    final image = await captureWidgetAsImage(globalKey);
    final bytes = await imageToBytes(image);

    // Convert image to PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Image(
            pw.MemoryImage(bytes),
          ),
        ),
      ),
    );

    // Conversion des données en tableau d'octets (Uint8List)
    // On convertit les données en un tableau d'octets (Uint8List),
    // ce qui représente l'image au format PNG
    try{
      Uint8List fileBytes = await pdf.save();
      // On crée un emet événement (PartagerRecuEvent) avec des informations
      // telles que le nom du fichier, la description
      // et les données de l'image à partagé
      await Share.shareXFiles(
        [
          XFile.fromData(
            fileBytes,
            name: 'reçu-${transaction.endToEndId}.pdf',
            mimeType: 'application/pdf',
          ),
        ],
        subject: traductions.transactionDetailsRecuTitle,
      );
    }catch(e){
      debugPrint("====> error $e");
    }
  }

  Future<ui.Image> captureWidgetAsImage(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return await boundary.toImage(pixelRatio: 3.0);
  }

  Future<Uint8List> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}