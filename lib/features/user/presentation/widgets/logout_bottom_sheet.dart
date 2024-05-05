import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../../core/utils/common_utils.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0).copyWith(bottom: 0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.sureToLogout,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    AppLocalizations.of(context)!.nextTimeSecurity,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await logout(redirect: true, clearCache: false);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.yes,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.drag_handle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
