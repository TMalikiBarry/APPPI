import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../core/di.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
import '../../../security/domain/models/connected_user.dart';
import '../../../security/presentation/bloc/login/login_bloc.dart';
import '../bloc/qrcode_alias/qrcode_alias_bloc.dart';
import '../bloc/qrcode_alias/qrcode_alias_event.dart';
import '../bloc/qrcode_alias/qrcode_alias_state.dart';
import 'qrcode_alias_page_avatar.dart';
import 'qrcode_alias_page_image.dart';
import 'qrcode_alias_page_share.dart';
import 'qrcode_switch_btn.dart';

class QrCodeAliasPage extends StatelessWidget {
  const QrCodeAliasPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    final GlobalKey globalKey = GlobalKey();

    // Pour récuperer les informations de l'utilisateur
    final loginBloc = context.read<LoginBloc>();
    final ConnectedUser user = loginBloc.getConnectedUser()!;

    // Pour récuperer l'alias
    final aliasBloc = context.read<AliasBloc>();
    final AliasExistState aliasState = aliasBloc.state as AliasExistState;

    // Bloc Affichage QR Code
    QrcodeAliasBloc qrcodeAliasBloc =
        QrcodeAliasBloc(Di.getQrcodeInputPort()) //
          ..add(QrcodeAliasEncodeEvent(aliasState.alias));

    String? qrCode;

    return BlocProvider<QrcodeAliasBloc>(
      create: (_) => qrcodeAliasBloc,
      child: BlocConsumer<QrcodeAliasBloc, QrcodeAliasState>(
          bloc: qrcodeAliasBloc,
          listenWhen: (previous, current) =>
              current is QrcodeAliasEncodeSuccessState ||
              current is QrcodeAliasEncodeErrorState ||
              current is QrcodeAliasInitialState,
          listener: (context, state) {
            if (state is QrcodeAliasEncodeSuccessState) {
              qrCode = state.qrCode;
            } //
            else if (state is QrcodeAliasEncodeErrorState) {
              debugPrint(" QrcodeAliasEncodeErrorState ${state.error}");

              // Afficher message d'erreur
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(traductions.qrcodeEncodeErrorMsg),
                ),
              );

              AppRouter.pushReplacement(
                context,
                AppRouter.home,
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => AppRouter.pushReplacement(
                    context,
                    AppRouter.home,
                  ),
                  icon: const Icon(Icons.close),
                ),
                actions: [
                  IconButton(
                    onPressed: () => {
                      _share(
                          context, qrcodeAliasBloc, user.firstName, globalKey),
                    },
                    icon: Icon(
                      Platform.isIOS ? Icons.ios_share : Icons.share_rounded,
                    ),
                  ),
                ],
              ),
              body: MyPageContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom et photo de l'utilisateur
                    const QrcodeAliasPageAvatar(),
                    //
                    const SizedBox(height: 40),
                    // Image du QR Code
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: RepaintBoundary(
                        key: globalKey,
                        child: qrCode != null
                            ? QrCodeAliasPageImage(qrCode: qrCode!)
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 5.2,
                    vertical: 20.0),
                height: 64,
                child: QrcodeSwitchBtn(
                  cardBgColor: const Color(0x99151413),
                  items: [
                    QrcodeBtnItem(
                      text: traductions.qrcodePageBtnScan,
                      textColor: Themer.whiteColor,
                      btnColor: Colors.transparent,
                      action: () {
                        AppRouter.push(
                          context,
                          AppRouter.qrcodeScan,
                        );
                      },
                    ),
                    QrcodeBtnItem(
                      text: traductions.qrcodePageBtnMonCode,
                      textColor: const Color(0xFF151413),
                      btnColor: Themer.whiteColor,
                      action: () {},
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _share(
    BuildContext context,
    QrcodeAliasBloc qrcodeAliasBloc,
    String name,
    GlobalKey globalKey,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Page options de partage
        return QrcodeAliasPageShare(
          qrcodeAliasBloc: qrcodeAliasBloc,
          globalKey: globalKey,
          username: name,
        );
      },
    );
  }
}
