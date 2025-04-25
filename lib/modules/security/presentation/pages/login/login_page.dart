import 'package:flutter/material.dart';
import 'login_page_demo.dart';
import 'login_page_webview.dart';

import '../../../../../core/env.dart';

class LoginPage extends StatelessWidget {
  //
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    if (AppEnv.mode == "demo") {
      return const LoginPageDemo();
    } //
    else {
      return const LoginPageWebView();
    }
  }
}
