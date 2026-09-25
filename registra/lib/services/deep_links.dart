import 'dart:async';
import 'package:registra/services/navigation.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:registra/login%20and%20register/change_pass.dart';


class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? sub;
  Future<void> init() async {
    final Uri? initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      handleUri(initialUri);
    }
    sub = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        handleUri(uri);
      },
      onError: (error) {
        print(error);
      },
    );
  }

  void handleUri(Uri uri) async {
    if (uri.queryParameters.containsKey("error")) {
    print(uri.queryParameters["error_description"]);
    return;
  }

    if (uri.host == "reset-password") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const ForgPassPage()),
      );
    }
  }
}
