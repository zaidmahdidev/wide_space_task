import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_validation/flutter_validation.dart';
import 'package:get/get.dart';

import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/cached_network_image.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/models/service_point_model.dart';

class ServicePointPreview extends StatelessWidget {
  const ServicePointPreview(
      {Key? key,
      required this.servicePointModel,
      required this.userLocationAvailable})
      : super(key: key);

  final ServicePointModel servicePointModel;
  final bool userLocationAvailable;

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
                  if (servicePointModel.name != null) ...[
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
                          AttributeLocalizations.of(context)!.name,
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
                            servicePointModel.name!,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    height: .6,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (servicePointModel.locationDescription != null) ...[
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
                            Icons.description,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        Text(
                          AttributeLocalizations.of(context)!.description,
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
                            servicePointModel.locationDescription!,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    height: .6,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (servicePointModel.images.isNotEmpty) ...[
                    Container(
                      height: 180,
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.all(8.0),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: cachedNetworkImage(
                                servicePointModel.images[index].path!,
                                rounded: false),
                          );
                        },
                        itemCount: servicePointModel.images.length,
                      ),
                    ),
                  ],
                  if (userLocationAvailable) ...[
                    PrimaryButton(
                        text: AppLocalizations.of(context)!.showRoad,
                        onTap: () {
                          Get.back(result: true);
                        })
                  ],
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
                    '${imagesPath}logo.png',
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

  static Future<bool> show({
    required ServicePointModel servicePoint,
    required bool userLocationAvailable,
  }) async {
    bool? showDirectionsToPoints = await Get.bottomSheet(
        ServicePointPreview(
          servicePointModel: servicePoint,
          userLocationAvailable: userLocationAvailable,
        ),
        isScrollControlled: true);

    return showDirectionsToPoints ?? false;
  }
}
