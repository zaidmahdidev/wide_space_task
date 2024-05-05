import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostsShimmer extends StatelessWidget {
  const PostsShimmer({
    Key? key,
    required this.avatars,
    required this.imageSize,
    required this.shift,
  }) : super(key: key);

  final List<Widget> avatars;
  final double imageSize;
  final double shift;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        enabled: true,
        direction: ShimmerDirection.ttb,
        baseColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        highlightColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(.1),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 4,
                      offset: const Offset(0, 4)),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 56,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text("##############",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary))),
                                Text(
                                  "#####",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              ],
                            ),
                            Text("########",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("XXXXXXXXXXXXXXXXXXX",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  const Icon(
                    Icons.image,
                    size: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      maxLines: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: avatars
                          .asMap()
                          .map((index, item) {
                            double left = imageSize + shift;
                            final value = Container(
                              margin: EdgeInsets.only(left: left * index),
                              child: item,
                            );
                            return MapEntry(index, value);
                          })
                          .values
                          .toList()
                          .reversed
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: 15,
        ));
  }
}
