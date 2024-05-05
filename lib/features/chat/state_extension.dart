import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/network_info.dart';
import '../../injection_container.dart';

extension ScaffoldStateExtension<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  Future<bool> ensureConnectivity() async {
    if (!await sl<NetworkInfo>().isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.checkInternetConnection)),
      );

      return false;
    }

    return true;
  }

  void showSnackBarError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.unexpectedFailure)),
    );
  }

  void handleError(error) {
    // Handle Error
  }
}
