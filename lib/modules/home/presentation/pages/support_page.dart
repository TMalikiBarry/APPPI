/*import 'dart:io';
import 'package:common_dependencies/utils/colors.dart';
import 'package:common_dependencies/utils/constants.dart';
import 'package:common_dependencies/utils/enum.dart';
import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  const SupportPage({super.key, this.fromTab = false});
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  SupportInfo? supportInfo;
  String? whatsappPhone;
  String? phoneNumberSupport;
  bool isLoading = true;
  ServiceInterne? serviceTr;

  @override
  Widget build(BuildContext context) {
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
              return SizedBox(
                  height: MediaQuery.of(context).copyWith().size.height * 0.35,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 30 * fem, horizontal: 10 * fem),
                      height:
                      MediaQuery.of(context).copyWith().size.height * 0.3 * fem,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                AppLocalizations.of(context)!.contact_service_client,
                                style: CustomTextStyle.titleBottomSheetSupportTextStyle,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                /*whatsappPhone = supportInfo != null && supportInfo!.phoneSupport != null && supportInfo!.phoneSupport!.length > 1 ? supportInfo?.phoneSupport!.split("|")[1] : "";

                            final whatsappUrl = Uri.parse("whatsapp://send?phone=$whatsappPhone");

                            if (await canLaunchUrl(whatsappUrl)) {
                              await launchUrl(whatsappUrl);
                            } else {
                              // fallback vers web
                              final webUrl = Uri.parse("https://api.whatsapp.com/send?phone=$whatsappPhone");
                              if (await canLaunchUrl(webUrl)) {
                                await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                              } else {
                                print("WhatsApp not installed");
                              }
                            }
                             */
                                final whatsappUrl = Uri.parse("whatsapp://send?phone=$whatsappPhone");
                                if (await canLaunchUrl(whatsappUrl)) {
                                  await launchUrl(whatsappUrl);
                                } else {
                                  // fallback vers web
                                  final webUrl = Uri.parse("https://api.whatsapp.com/send?phone=$whatsappPhone");
                                  if (await canLaunchUrl(webUrl)) {
                                    await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                                  } else {
                                  }
                                }
                              },
                              child: ListTile(
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
                                ) : Text(
                                  whatsappPhone != null
                                      ? formatPhoneNumberUser("+$whatsappPhone", international: true)
                                      : AppLocalizations.of(context)!.contact_us_whatsapp,
                                  style: CustomTextStyle.titleSupportTextStyle,
                                ),
                                subtitle: Text(
                                  AppLocalizations.of(context)!.contact_us_whatsapp_desc,
                                  style: CustomTextStyle.subTitleSupportTextStyle,
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    String message = AppLocalizations.of(context)!
                                        .contact_us_default_message;
                                    String url = Platform.isAndroid
                                        ? "https://wa.me/${supportInfo?.phoneSupport!.split("|")[1]}"
                                        : "https://api.whatsapp.com/send?phone=${supportInfo?.phoneSupport!.split("|")[1]}";
                                    if (!await launch(url)) {
                                      throw 'Could not launch whatsapp  $url';
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios_sharp),
                                ),
                                onTap: () async {

                                  /*String message = AppLocalizations.of(context)!
                                  .contact_us_default_message;
                              String url = Platform.isAndroid
                                  ? "https://wa.me/${supportInfo?.phoneSupport!.split("|")[1]}"
                                  : "https://api.whatsapp.com/send?phone=${supportInfo?.phoneSupport!.split("|")[1]}";
                              if (!await launch(url)) {
                                throw 'Could not launch whatsapp  $url';
                              }*/

                                  final whatsappUrl = Uri.parse("whatsapp://send?phone=$whatsappPhone");

                                  if (await canLaunchUrl(whatsappUrl)) {
                                    await launchUrl(whatsappUrl);
                                  } else {
                                    // fallback vers web
                                    final webUrl = Uri.parse("https://api.whatsapp.com/send?phone=$whatsappPhone");
                                    if (await canLaunchUrl(webUrl)) {
                                      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                                    }
                                  }

                                },
                              ),
                            ),
                            /*customTextButton(
                            Image.asset("assets/images/whatsapp.png",
                                package: "common_dependencies",
                                height: 20,
                                width: 20),
                            AppLocalizations.of(context)!.contact_us_whatsapp,
                            () async {
                          print("Contact us by whatsappp");
                          String message = AppLocalizations.of(context)!
                              .contact_us_default_message;
                          String url = Platform.isAndroid
                              ? "https://wa.me/${supportInfo?.phoneSupport!.split("|")[1]}"
                              : "https://api.whatsapp.com/send?phone=${supportInfo?.phoneSupport!.split("|")[1]}";
                          if (!await launch(url)) {
                            throw 'Could not launch whatsapp  $url';
                          }
                        }),*/
                            SizedBox(height: 8 * fem),
                            /*GestureDetector(
                              onTap: () async {
                                Uri uri = Uri(
                                    scheme: 'tel', path: phoneNumberSupport);
                                if (!await launchUrl(uri)) {
                                  throw 'Could not launch ${uri.path}';
                                }
                              },
                              child:*/
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
                                  child: Icon(Icons.call_outlined,size: 20, color: primaryColor),
                                ),
                                title: isLoading
                                    ? LoadingAnimationWidget.flickr(
                                  leftDotColor: primaryColor,
                                  rightDotColor: secondaryColor,
                                  size: 25,
                                ) : Text(
                                  phoneNumberSupport != null
                                      ? formatPhoneNumberUser(phoneNumberSupport!)
                                      : AppLocalizations.of(context)!.contact_us_phone_title,
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
                                  icon: Icon(Icons.arrow_forward_ios_sharp),
                                ),
                              ),
                            //),
                            /*customTextButton(
                            const Icon(Icons.call_outlined,
                                size: 20, color: primaryColor),
                            AppLocalizations.of(context)!.contact_us_phone,
                            () async {
                          Uri uri = Uri(
                              scheme: 'tel', path: supportInfo?.phoneSupport!.split("|")[0]);
                          print("Contact us by phone ${uri.toString()}");
                          if (!await launchUrl(uri)) {
                            throw 'Could not launch ${uri.path}';
                          }
                        }),*/
                            /*SizedBox(height: 8 * fem),
                        customTextButton(
                            const Icon(Icons.mail_outline,
                                size: 20, color: secondaryColor),
                            AppLocalizations.of(context)!.contact_us_mail,
                            () async {
                          Uri uri = Uri(
                              scheme: 'mailto',
                              path: supportInfo?.emailSupport);
                          if (!await launchUrl(uri)) {
                            throw 'Could not launch mail ${uri.path}';
                          }
                        }),
                        SizedBox(height: 8 * fem),
                        customTextButton(
                            const Icon(Icons.sms_outlined,
                                size: 20, color: dodgerBlue),
                            AppLocalizations.of(context)!.contact_us_sms,
                            () async {
                          String message = AppLocalizations.of(context)!
                              .contact_us_default_message;
                          String path =
                              "${supportInfo?.phoneSupport!.split("\\|")[0]}?body=$message";
                          Uri uri = Uri(scheme: 'sms', path: path);
                          print("Contact us by sms ${uri.toString()}");
                          if (!await launchUrl(uri)) {
                            throw 'Could not launch sms ${uri.path}';
                          }
                        }),*/
                          ])));
            })));
  }
}

 */
