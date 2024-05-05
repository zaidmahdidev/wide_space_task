import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class ServicePointsLoadingWidget extends StatelessWidget {
  const ServicePointsLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          '${lottieAnimationsPath}location_loading.json',
          height: 100,
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: SpinKitPulse(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          size: 240,
        ),
      )
    ]);
  }
}
