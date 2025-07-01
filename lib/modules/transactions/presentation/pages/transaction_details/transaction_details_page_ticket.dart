import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/models/transaction.dart';

class TransactionDetailsPageTicket extends StatefulWidget {
  const TransactionDetailsPageTicket({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  State<TransactionDetailsPageTicket> createState() =>
      _TransactionDetailsPageTicketState();
}

class _TransactionDetailsPageTicketState
    extends State<TransactionDetailsPageTicket> {
  //
  final logger = Logger();

  /// Chemin vers le ticket de caisse
  String? tickePath;

  @override
  void initState() {
    super.initState();
    // Rechercher le ticket de caisse
    _getTicketPath();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    if (tickePath == null) {
      return TextButton.icon(
        onPressed: () => showModalBottomSheet<File?>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return _sheetTeleverser(context, traductions);
          },
          isScrollControlled: true,
        ).then((File? value) {
          if (value != null) {
            _saveTicket(value);
          }
        }),
        icon: const Icon(Icons.camera_alt_outlined),
        label: Text(traductions.transactionDetailsTeleverser),
      );
    }
    // Bouton téléverser
    else {
      return InkWell(
        onTap: () => showModalBottomSheet<bool?>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return _sheetVisualiser(context, traductions);
          },
          isScrollControlled: true,
        ),
        borderRadius: BorderRadius.circular(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(tickePath!),
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  /// Rechercher le ticket de caisse
  void _getTicketPath() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${widget.transaction.endToEndId}.png';
      if (await File(path).exists()) {
        setState(() {
          tickePath = path;
        });
      }
    } catch (e) {
      debugPrint("Can not load ticket de caisse");
    }
  }

  /// Enregistrer le ticket de caisse
  void _saveTicket(File file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${widget.transaction.endToEndId}.png';
      // Copier le fichier image dans le répertoire de stockage local
      File newFile = await file.copy(path);
      if (await newFile.exists()) {
        setState(() {
          setState(() {
            tickePath = path;
          });
        });
      }
    } catch (e) {
      debugPrint("Cannot save ticket");
      // TODO afficher un message d'erreur
    }
  }

  /// Bottom sheet pour téléverser un ticket de caisse
  Widget _sheetTeleverser(
    BuildContext context,
    AppLocalizations traductions,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  traductions.transactionDetailsTicketSaveTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                //
                const SizedBox(height: 10),

                SizedBox(
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Prendre une photo avec la camera
                      InkWell(
                        onTap: () => _pickImage(context, ImageSource.camera),
                        child: Container(
                          width: 77,
                          height: 80,
                          decoration: ShapeDecoration(
                            color: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            image: const DecorationImage(
                              image: AssetImage(Images.ticketCaisse,package: 'common_dependencies'),
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      // Photos recentes
                      Expanded(
                        child: SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [], // TODO afficher la liste
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //
                const SizedBox(height: 20.0),

                // Selectionner une photo depuis la galery
                Card(
                  child: ListTile(
                    onTap: () => _pickImage(context, ImageSource.gallery),
                    leading: const Icon(Icons.image_rounded),
                    title: Text(
                      traductions.transactionDetailsTicketSaveGallery,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Ouvrir la galerie
  void _pickImage(context, ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      AppRouter.pop(context, value: File(image.path));
    }
  }

  /// Bottom sheet pour visualiser le ticket de caisse
  Widget _sheetVisualiser(BuildContext context, AppLocalizations traductions) {
    final File file = File(tickePath!);
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.2,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Boutton retour et partager
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Boutton retour
                  BackButton(onPressed: () => AppRouter.pop(context)),
                  // Boutton partager
                  IconButton(
                    onPressed: () => _shareTicket(context, file, traductions),
                    icon: Icon(
                      Platform.isIOS ? Icons.ios_share : Icons.share_rounded,
                    ),
                  ),
                ],
              ),
              //
              const SizedBox(height: 20),

              // Image du ticket de caisse
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //
                        const SizedBox(height: 20),
                        // Title Reçu réglè
                        Text(
                          traductions.transactionDetailsTicketCaisse,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        // SubTitle Vous pouvez partager ou télécharger le PDF
                        Text(
                          traductions.transactionDetailsTicketCaisseSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        //
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(file, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Supprimer Btn
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () => _deleteTicket(),
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: Themer.systemErrorColor,
                ),
                label: Text(
                  traductions.btnTextDelete,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Themer.systemErrorColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Partager le ticket de caisse
  void _shareTicket(
    BuildContext context,
    File file,
    AppLocalizations traductions,
  ) async {
    // Conversion des données en tableau d'octets (Uint8List)
    // On convertit les données en un tableau d'octets (Uint8List),
    // ce qui représente l'image au format PNG
    try {
      Uint8List fileBytes = await file.readAsBytes();
      String filePath = file.path;
      String fileName = filePath.split('/').last;
      String fileNameWithoutExtension = fileName.split('.').first;
      String extension = fileName.split('.').last.toLowerCase();

      // Définir le mimeType en fonction de l'extension
      String mimeType;
      switch (extension) {
        case 'png':
          mimeType = 'image/png';
          break;
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        default:
          mimeType = 'application/octet-stream'; // générique si inconnu
      }

      // On crée un emet événement (PartagerRecuEvent) avec des informations
      // telles que le nom du fichier, la description
      // et les données de l'image à partagé
      await Share.shareXFiles(
        [
          XFile.fromData(
            fileBytes,
            name: 'reçu-$fileNameWithoutExtension.$extension',
            mimeType: mimeType,
          ),
        ],
        subject: traductions.transactionDetailsTicket,
      );
    } catch (e) {
      logger.e("Error while sharing ticket", error: e);
    }
  }

  /// Supprimer le ticket de caisse
  void _deleteTicket() async {
    await File(tickePath!).delete();
    setState(() {
      tickePath = null;
      AppRouter.pop(context, value: true);
    });
  }
}
