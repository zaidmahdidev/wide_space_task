import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/constants.dart';
import '../../../data/models/user_model.dart';

class Progress extends StatelessWidget {
  const Progress({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(
          AppLocalizations.of(context)!.statistics,
          style: AppTheme.textTheme.titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_circle_up_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            Expanded(
              flex: 2,
              child: Text(
                AppLocalizations.of(context)!.level,
                style: AppTheme.textTheme.titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 3,
              child: Text(
                (user.statistics?.level ?? 1).toInt().toString(),
                style: AppTheme.textTheme.labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        const Divider(
          indent: 64,
          endIndent: 64,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.stacked_bar_chart_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            Expanded(
              flex: 3,
              child: Text(
                AppLocalizations.of(context)!.progress,
                style: AppTheme.textTheme.titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 3,
              child: Text(
                "${((user.statistics?.progress ?? 0) * 100).toInt()}%",
                style: AppTheme.textTheme.labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        const Divider(
          indent: 64,
          endIndent: 64,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.tag_faces_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            Expanded(
              flex: 3,
              child: Text(
                AppLocalizations.of(context)!.nickName,
                style: AppTheme.textTheme.titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 3,
              child: Text(
                user.statistics?.nickname ??
                    AppLocalizations.of(context)!.noNickName,
                style: AppTheme.textTheme.labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        const Divider(
          indent: 64,
          endIndent: 64,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.celebration_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            Expanded(
              flex: 6,
              child: Text(
                AppLocalizations.of(context)!.achievements,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Stack(
              children: [
                SizedBox(
                  width: 40,
                  child: Image.asset(
                    '${imagesPath}logo.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: Get.locale == const Locale('ar', 'YE') ? 0 : 16,
                    right: Get.locale == const Locale('ar', 'YE') ? 16 : 0,
                  ),
                  width: 40,
                  child: Image.asset(
                    '${imagesPath}logo.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: Get.locale == const Locale('ar', 'YE') ? 0 : 32,
                    right: Get.locale == const Locale('ar', 'YE') ? 32 : 0,
                  ),
                  width: 40,
                  child: Image.asset(
                    '${imagesPath}logo.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: Get.locale == const Locale('ar', 'YE') ? 0 : 48,
                    right: Get.locale == const Locale('ar', 'YE') ? 48 : 0,
                  ),
                  width: 40,
                  child: Image.asset(
                    '${imagesPath}logo.png',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: Get.locale == const Locale('ar', 'YE') ? 0 : 64,
                    right: Get.locale == const Locale('ar', 'YE') ? 64 : 0,
                  ),
                  width: 40,
                  child: Image.asset(
                    '${imagesPath}logo.png',
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        Text(
          AppLocalizations.of(context)!.basicInfo,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
