import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/current_provider.dart';

CachedNetworkImage cachedNetworkImage(String image,
    {double? width,
    double? height,
    onFailed,
    bool rounded = true,
    bool provider = false,
    Widget? errorWidget,
    String? baseUrl,
    BoxFit? fit}) {
  return CachedNetworkImage(
    fit: fit ?? BoxFit.cover,
    width: width,
    height: height,
    imageUrl: image.isNotEmpty
        ? image
        : (baseUrl == null
            ? (Current.user.avatar ?? "") + image
            : baseUrl + image),
    imageBuilder: provider
        ? (context, imageProvider) => CircleAvatar(
              radius: 1000,
              backgroundImage: imageProvider,
            )
        : null,
    placeholder: (context, url) => Center(
        child: ClipRRect(
      borderRadius: rounded ? BorderRadius.circular(1000) : BorderRadius.zero,
      child: Lottie.asset(
        '${lottieAnimationsPath}image_loading.json',
        fit: BoxFit.cover,
        height: height ?? double.infinity,
        width: width ?? double.infinity,
      ),
    )),
    errorWidget: (context, url, error) {
      if (onFailed != null) onFailed();
      return errorWidget ??
          Center(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              '${imagesPath}logo.png',
              fit: BoxFit.cover,
              height: height ?? double.infinity,
              width: width ?? double.infinity,
            ),
          ));
    },
    // httpHeaders: getAuthHeaders(),
  );
}
