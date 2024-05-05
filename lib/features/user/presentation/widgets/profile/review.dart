import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../../core/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../pages/profile/reviews_screen.dart';

class ReviewSection extends StatefulWidget {
  const ReviewSection({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel user;

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RatingBar.builder(
            initialRating: widget.user.statistics?.rating ?? 0,
            minRating: 1,
            allowHalfRating: true,
            direction: Axis.horizontal,
            itemCount: 5,
            ignoreGestures: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: AppTheme.gold,
            ),
            onRatingUpdate: (rating) {
              if (kDebugMode) {
                print(rating);
              }
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
          onPressed: () {
            Get.to(() => ReviewsScreen(
                  user: widget.user,
                  other: false,
                ));
          },
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          child: Text(AppLocalizations.of(context)!.seeReviews),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
