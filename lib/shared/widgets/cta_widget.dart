import 'package:common_dependencies/utils/colors.dart';
import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:micro_core/services/routing/routes.dart';
import 'package:micro_core/services/routing/routing.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/src/widgets/framework.dart';


class CtaWidget extends StatelessWidget {
  const CtaWidget({
    super.key,
    required this.label,
    required this.action,
    this.icon,
    this.image,
    this.disabled = false,
    this.message,
  });

  final String label;
  final Function()? action;
  final Icon? icon;
  final String? image;
  final bool disabled;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    const Color bg = Themer.backgroundPiProgramme;
    final shadow = BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    );

    return GestureDetector(
      onTap: () async {
        if (!disabled) {
          action?.call();
        } else {
          await Future.delayed(Duration(milliseconds: 50));
          _showBottomSheetDeplafonne(context);
        }
      },
      child: Opacity(
        // Opacité réduite si disabled
        opacity: disabled ? 0.28 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Themer.backgroundPiProgramme,
                shape: BoxShape.circle,
                //boxShadow: [shadow],
                /*border: !disabled ? Border.all(
                  color: const Color(0xFF646FEF), // couleur #646FEF
                  width: 2, // fine bordure
                ) : null,*/
              ),
              child: Center(
                child: icon ??
                  Image(
                    image: AssetImage(image!, package: 'common_dependencies'),
                    height: 28,
                    width: 28,
                    //size: 28,
                    //color: const Color(0xFF282C5D),
                  ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Themer.primaryColor, fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheetDeplafonne(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 120),
      ),
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(16),
            height: MediaQuery.of(context).copyWith().size.height * 0.45,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  10.height,
                  Container(
                      margin: EdgeInsets.only(left: 25),
                      child: SvgPicture.asset(
                        'assets/images/alert.svg',
                        height: 80,
                        width: 80,
                        package: "common_dependencies",
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 25),
                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.height,
                            Text(
                              AppLocalizations.of(context)!.augmenter_palfond,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            10.height,
                            Text(
                              AppLocalizations.of(context)!.description_plafon,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              AppLocalizations.of(context)!.exemple_prix,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            10.height,
                            Text(
                              AppLocalizations.of(context)!.description_simple,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ])),
                  10.height,
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(secondaryColor),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Text( AppLocalizations.of(context)!.upgrade_kyc, style: safeGoogleFont('Lato', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Routing.pushNamed(
                            Routes.deplafonnerWalletTFS,
                            arguments: RouteEvents.walletTFSEvents.userWalletTFSLoggedInEvent("Wallet TFS"),
                          );
                        },
                      ),
                    ),
                  ),
                  10.height,
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: primaryColor, // couleur de la bordure
                          width: 1.0,         // épaisseur
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.transactionDetailsAnnuler, style: safeGoogleFont('Lato', color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                ]),
          );
        }
    );
    }
}
