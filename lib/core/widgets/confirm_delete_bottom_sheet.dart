import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../utils/screen_util.dart';

class SureToDeleteBottomSheet extends StatelessWidget {
  final String? subtitle;

  const SureToDeleteBottomSheet({Key? key, this.subtitle}) : super(key: key);

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
                  SvgPicture.asset(
                    'assets/images/question.svg',
                    height: ScreenUtil.screenWidth / 4,
                    width: ScreenUtil.screenWidth / 4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.sureToDelete,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (subtitle != null) ...[
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back(result: true);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.yes,
                                ))),
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
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 70,
              child: IgnorePointer(
                child: Opacity(
                  opacity: .025,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: ScreenUtil.screenHeight / 1.5,
                  ),
                ),
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

  static Future<bool?> show({String? subtitle}) async {
    return await Get.bottomSheet(SureToDeleteBottomSheet(
      subtitle: subtitle,
    ));
  }
}
