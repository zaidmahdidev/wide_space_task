import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/screen_util.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? type;
  final String? receiver;
  final String? receiverPhone;
  final num? gross;
  final num? fee;
  final num? net;
  final num? rate;
  final String symbol;
  final void Function()? onConfirm;
  final void Function()? onCancel;
  final void Function()? onReject;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text(
                      subTitle,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    height: 24,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                  if (receiver != null && receiver!.isNotEmpty) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.account_circle,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.receiverName,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  height: 1.3,
                                  fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 0,
                        ),
                        Expanded(
                          child: Text(
                            receiver!,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    height: .8,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (receiverPhone != null && receiverPhone!.isNotEmpty) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.account_circle,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.receiverPhone,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  height: 1.3,
                                  fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 0,
                        ),
                        Text(
                          receiverPhone!.substring(3).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: .6,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  if (type != null) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.category,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.type,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  height: 1.3,
                                  fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 0,
                        ),
                        Text(
                          "$type",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: .6,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  if (gross != null) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.paid,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.gross,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  height: 1.3,
                                  fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 0,
                        ),
                        Text(
                          "${NumberFormat("###,###").format(gross)} $symbol",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: .6,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  if (net != null) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.payments,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.net,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  height: 1.3,
                                  fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 0,
                        ),
                        Text(
                          "${NumberFormat("###,###").format(net)} $symbol",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: .6,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  if (fee != null) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.add_circle,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.fee,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  height: 1.3,
                                  fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 0,
                        ),
                        Text(
                          "${NumberFormat("###,###").format(fee)} $symbol",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: .6,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  if (rate != null && rate != 0) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.change_circle,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.priceRate,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  height: 1.3,
                                  fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 0,
                        ),
                        Text(
                          "${NumberFormat("###,###").format(rate)} $symbol",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: .6,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        if (onConfirm != null) ...[
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    onConfirm!();
                                    Get.back();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.yes,
                                  ))),
                        ],
                        const SizedBox(
                          width: 8,
                        ),
                        if (onCancel != null) ...[
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              onCancel!();
                              Get.back();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                            ),
                          )),
                        ],
                        if (onReject != null) ...[
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              onReject!();
                              Get.back();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.reject,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )),
                        ],
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

  const ConfirmationBottomSheet({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.symbol,
    this.type,
    this.receiver,
    this.receiverPhone,
    this.gross,
    this.fee,
    this.net,
    this.rate,
    this.onConfirm,
    this.onCancel,
    this.onReject,
  }) : super(key: key);

  static void show({
    required String title,
    required String subTitle,
    required String symbol,
    String? type,
    String? receiver,
    String? receiverPhone,
    num? gross,
    num? fee,
    num? net,
    num? rate,
    void Function()? onConfirm,
    void Function()? onCancel,
    void Function()? onReject,
  }) {
    Get.bottomSheet(
        ConfirmationBottomSheet(
          title: title,
          subTitle: subTitle,
          symbol: symbol,
          type: type,
          receiver: receiver,
          receiverPhone: receiverPhone,
          gross: gross,
          fee: fee,
          net: net,
          rate: rate,
          onConfirm: onConfirm,
          onCancel: onCancel,
          onReject: onReject,
        ),
        isScrollControlled: true);
  }
}
