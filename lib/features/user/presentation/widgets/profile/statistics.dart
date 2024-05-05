import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/models/user_model.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel user;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.requests,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              (widget.user.totalPosts ?? 0).toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.responses,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              (widget.user.totalComments ?? 0).toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              AppLocalizations.of(context)!.friends,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              (widget.user.totalFriends ?? 0).toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ],
    );
  }
}
