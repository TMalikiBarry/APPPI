import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/router.dart';
import '../../../../../shared/widgets/error_page.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../domain/models/login_command.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';

class LoginPageWebView extends StatefulWidget {
  //final String uri;
  const LoginPageWebView({super.key});

  @override
  State<LoginPageWebView> createState() => _LoginPageWebViewState();
}

class _LoginPageWebViewState extends State<LoginPageWebView> {
  //
  static final logger = Logger();
  late WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    //
    super.initState();
    //
    logger.i('CREATION DE GRANT');

    // URL du server d'auth
    // Récupération du bloc de sécurité
    LoginBloc loginBloc = context.read<LoginBloc>();
    Uri authorizationUrl = loginBloc.connexionInputPort.getAuthorizationUrl();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) async {
            logger.i('URL REDIRECT: $url');
            setState(() {
              loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            logger.e('onWebResourceError', error: error);
            NavigationDecision.prevent;
            loginBloc.add(const CheckSessionEvent());
          },
          onNavigationRequest: (NavigationRequest request) async {
            logger.i('Request URL ${request.url}');
            if (request.url.startsWith('myapp://login')) {
              loginBloc.add(
                ConnexionEvent(
                  LoginCommand(
                    username: LoginCommandUsername(value: request.url),
                    password: LoginCommandPassword(
                      value: "P@sser123",
                    ),
                  ),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(authorizationUrl);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      // Build form
      builder: (context, loginState) {
        if (loginState is LoginErrorState) {
          return ErrorPage(
            bgColor: Theme.of(context).colorScheme.surface,
            type: ErrorType.internetError,
            retry: () {
              AppRouter.pushReplacement(context, AppRouter.login);
              context.read<LoginBloc>().add(
                    FormChangedEvent(
                      LoginCommand(),
                      false,
                    ),
                  );
            },
          );
        } else {
          return Scaffold(
            body: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (loadingPercentage < 100) ...[
                  const LoadingPage(),
                ],
              ],
            ),
          );
        }
      },
      listener: (context, state) {
        // Si succed,
        if (state is LoginSuccessState) {
          // Navigate to change password screen
          // Because I assume that it's the only challenge implemented
          AppRouter.push(context, AppRouter.identificationInitial);
        }
      },
    );
  }
}
