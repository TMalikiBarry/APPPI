import 'dart:io';
import 'package:common_dependencies/utils/colors.dart';
import 'package:common_dependencies/utils/constants.dart';
import 'package:common_dependencies/utils/enum.dart';
import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_tfs_app/bloc/service_interne/ServiceInterneBloc.dart';
import 'package:wallet_tfs_app/bloc/service_interne/ServiceInterneEvent.dart';
import 'package:wallet_tfs_app/bloc/service_interne/ServiceInterneState.dart';
import 'package:wallet_tfs_app/models/supportInfo.dart';
import 'package:wallet_tfs_app/repositories/ServiceInterne.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

class SupportPage extends StatefulWidget {
  final bool fromTab;
  const SupportPage({super.key, this.fromTab = false,});
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  SupportInfo? supportInfo;
  String? whatsappPhone;
  String? phoneNumberSupport;
  bool isLoading = true;
  ServiceInterne? serviceTr;
  String? whichCountry;
  @override
  void initState() {
    init();
    super.initState();
  }
  init()async{
    var pref = await SharedPreferences.getInstance();
    whichCountry = pref.getString('countryCode') ?? "SN";
    debugPrint("**************whichCountry$whichCountry****************");
  }
  @override
  Widget build(BuildContext context) {
    debugPrint("**************whichCountry$whichCountry****************");
    double fem = MediaQuery.of(context).size.width / BASEWIDTH;
    return RepositoryProvider<ServiceInterne>(
        create: (context) {
          return ServiceInterneImpl();
        },
        child: BlocProvider<ServiceInterneBloc>(create: (context) {
          serviceTr = RepositoryProvider.of<ServiceInterne>(context);
          return ServiceInterneBloc(serviceTr!)..add(GetSupportInfo());
        }, child: BlocBuilder<ServiceInterneBloc, ServiceInterneState>(
            builder: (context, state) {
              //logger.i("support info state $state");
              if (state is SuccessGetSupportInfo) {
                supportInfo = state.supportInfo;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  isLoading = false;
                  setState(() {
                    whatsappPhone = supportInfo != null && supportInfo!.phoneSupport != null && supportInfo!.phoneSupport!.length > 1 ? supportInfo?.phoneSupport!.split("|")[1] : "";
                    phoneNumberSupport = supportInfo != null && supportInfo!.phoneSupport != null && supportInfo!.phoneSupport!.length > 1 ? supportInfo?.phoneSupport!.split("|")[0] ?? "338434648" : "338434648";
                  });
                });
                ServiceInterneBloc(serviceTr!).add(BackEventService());
                //logger.i("supportInfo ${supportInfo!.toJson()}");
              }
              if (state is ErrorServices) {
                isLoading = false;
                ServiceInterneBloc(serviceTr!).add(BackEventService());
              }
              return SafeArea(child:
              SizedBox(
                 // height: MediaQuery.of(context).copyWith().size.height * 0.35,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 30 * fem, horizontal: 10 * fem),
                     // height: MediaQuery.of(context).copyWith().size.height * 0.3 * fem,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                AppLocalizations.of(context)!.contact_service_client,
                                style: CustomTextStyle.titleBottomSheetSupportTextStyle,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              leading: Container(
                                width: 38 * fem,
                                height: 38 * fem,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F6FF),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(8 * fem),
                                child: Image.asset(
                                  "assets/images/whatsapp.png",
                                  package: "common_dependencies",
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: isLoading
                                  ? LoadingAnimationWidget.flickr(
                                leftDotColor: primaryColor,
                                rightDotColor: secondaryColor,
                                size: 25,
                              )
                                  : Text( AppLocalizations.of(context)!.send_sms,
                                style: CustomTextStyle.titleSupportTextStyle,
                              ),
                              subtitle: Text(
                                AppLocalizations.of(context)!.contact_us_whatsapp_desc,
                                style: CustomTextStyle.subTitleSupportTextStyle,
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios_sharp),
                              onTap: () async {
                                //print("=== ListTile tapped ===");
                                //print("whatsappPhone: $whatsappPhone");

                                if (whatsappPhone == null) {
                                  //print("ERROR: whatsappPhone is null or empty");
                                  return;
                                }

                                try {
                                  // Nettoyer le numéro (enlever espaces, tirets, etc.)
                                  String cleanPhone = whatsappPhone!.replaceAll(RegExp(r'[^\d+]'), '');
                                  //print("Clean phone: $cleanPhone");

                                  String url = Platform.isAndroid
                                      ? "https://wa.me/$cleanPhone"
                                      : "https://api.whatsapp.com/send?phone=$cleanPhone";
                                  if (!await launch(url)) {
                                    throw 'Could not launch whatsapp  $url';
                                  }

                                  final whatsappUrl = Platform.isAndroid
                                      ? Uri.parse("https://wa.me/$cleanPhone")
                                      :  Uri.parse("https://api.whatsapp.com/send?phone=$cleanPhone");

                                  if (Platform.isAndroid && !await launch("https://wa.me/$cleanPhone")) {
                                  }
                                  //print("Trying URL: $whatsappUrl");

                                  if (await canLaunchUrl(whatsappUrl)) {
                                    //print("Can launch whatsapp:// URL");
                                    await launchUrl(whatsappUrl);
                                  } else {
                                    //print("Cannot launch whatsapp://, trying web fallback");
                                    final webUrl = Uri.parse("https://api.whatsapp.com/send?phone=$cleanPhone");
                                    //print("Trying web URL: $webUrl");

                                    if (await canLaunchUrl(webUrl)) {
                                      //print("Can launch web URL");
                                      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                                    } else {
                                      //print("ERROR: Cannot launch any WhatsApp URL");
                                    }
                                  }
                                } catch (e) {
                                  //print("ERROR launching WhatsApp: $e");
                                }
                              },
                            ),
                            if(whichCountry=="SN")...[
                              SizedBox(height: 8 * fem),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              leading: Container(
                                width: 38 * fem,
                                height: 38 * fem,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F6FF),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(8 * fem),
                                child: const Icon(Icons.call_outlined,size: 20, color: primaryColor),
                              ),
                              title: isLoading
                                  ? LoadingAnimationWidget.flickr(
                                leftDotColor: primaryColor,
                                rightDotColor: secondaryColor,
                                size: 25,
                              ) : Text(AppLocalizations.of(context)!.contact_us_phone_title,
                                style: CustomTextStyle.titleSupportTextStyle,
                              ),
                              subtitle: Text(
                                AppLocalizations.of(context)!.contact_us_phone_desc,
                                style: CustomTextStyle.subTitleSupportTextStyle,
                              ),
                              //trailing: trailing,
                              onTap: () async {
                                Uri uri = Uri(
                                    scheme: 'tel', path: phoneNumberSupport);
                                if (!await launchUrl(uri)) {
                                  throw 'Could not launch ${uri.path}';
                                }
                              },
                              trailing: IconButton(
                                onPressed: () async {
                                  Uri uri = Uri(
                                      scheme: 'tel', path: phoneNumberSupport);
                                  if (!await launchUrl(uri)) {
                                    throw 'Could not launch ${uri.path}';
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward_ios_sharp),
                              ),
                            ),
                            ]
                          ],
                      ),
                  ),
              ));
            },
        ),
      ),
    );
  }
}

