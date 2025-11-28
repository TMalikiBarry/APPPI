
import 'package:common_dependencies/utils/colors.dart';
import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:micro_core/micro_core.dart';

import '../../l10n/app_localizations.dart';

Future showBottomSheetDpl(ctext) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: ctext,
      isScrollControlled: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(ctext),
        duration: const Duration(milliseconds: 120),
      ),
      builder: (ctext) {
        return SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
         // height: MediaQuery.of(ctext).copyWith().size.height * 0.40,
          child:Column(
            mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10,),
                Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: SvgPicture.asset(
                        'assets/images/alert.svg',
                        height: 40,
                        width: 40,
                        package: "common_dependencies",
                      ),
                ),
                Container(
                      margin: const EdgeInsets.only(left: 25),
                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10,),
                            Text(
                              AppLocalizations.of(ctext)!.augmenter_palfond,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              AppLocalizations.of(ctext)!.description_plafon,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              AppLocalizations.of(ctext)!.exemple_prix,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              AppLocalizations.of(ctext)!.description_simple,
                              style: safeGoogleFont(
                                'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: disabledColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ])),
                  const SizedBox(height: 10,),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 5),
                      width: MediaQuery.of(ctext).size.width * 0.8,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(secondaryColor),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Text( AppLocalizations.of(ctext)!.upgrade_kyc, style: safeGoogleFont('Lato', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.of(ctext).pop();
                          Routing.pushNamed(
                            Routes.deplafonnerWalletTFS,
                            arguments: RouteEvents.walletTFSEvents.userWalletTFSLoggedInEvent("Wallet TFS"),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 10,),
                Center(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Colors.white,
                        minimumSize: Size(MediaQuery.of(ctext).size.width * 0.8, 48),
                      ),
                      child: Text(AppLocalizations.of(ctext)!.btnTextClose, style: safeGoogleFont('Lato', color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
                      onPressed: () {
                        Navigator.of(ctext).pop();
                      }
                  ),
                )
              ]),
        ));
      }
  );
}