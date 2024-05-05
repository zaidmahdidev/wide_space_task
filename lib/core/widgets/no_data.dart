import 'package:flutter/material.dart';

import '../utils/screen_util.dart';

class NoDataFull extends StatelessWidget {
  final String message;

  const NoDataFull({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Stack(
          children: [
            Positioned.fill(
              bottom: -ScreenUtil.screenHeight / 3,
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 22.0, horizontal: 8),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
