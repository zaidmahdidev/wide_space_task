import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/screen_util.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    required this.message,
    required this.onRefresh,
    this.generalError = true,
    this.fullHeight = false,
  }) : super(key: key);

  final String message;
  final bool generalError;
  final void Function()? onRefresh;
  final bool fullHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      height: !fullHeight ? ScreenUtil.screenHeight * .44 : null,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
              generalError
                  ? '${lottieAnimationsPath}error.json'
                  : '${lottieAnimationsPath}payment_error.json',
              height: ScreenUtil.screenHeight * .24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(height: 1.2),
                textAlign: TextAlign.center,
              ),
              IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh))
            ],
          ),
        ],
      ),
    );
  }
}
