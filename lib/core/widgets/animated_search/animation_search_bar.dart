import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/common_utils.dart';
import 'services.dart';

// ignore: must_be_immutable
class AnimationSearchBar extends StatelessWidget {
  AnimationSearchBar({
    Key? key,
    this.searchBarWidth,
    this.searchBarHeight,
    this.previousScreen,
    this.backIconColor,
    this.closeIconColor,
    this.searchIconColor,
    this.title,
    this.titleStyle,
    this.searchFieldHeight,
    this.searchFieldDecoration,
    this.cursorColor,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    required this.onChanged,
    required this.searchTextEditingController,
    this.horizontalPadding,
    this.verticalPadding,
    this.isBackButtonVisible,
    this.backIcon,
    this.duration,
  }) : super(key: key);

  ///
  final double? searchBarWidth;
  final double? searchBarHeight;
  final double? searchFieldHeight;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Widget? previousScreen;
  final Color? backIconColor;
  final Color? closeIconColor;
  final Color? searchIconColor;
  final Color? cursorColor;
  final String? title;
  final String? hintText;
  final bool? isBackButtonVisible;
  final IconData? backIcon;
  final TextStyle? titleStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Decoration? searchFieldDecoration;
  late Duration? duration;
  final Function(String) onChanged;

  final TextEditingController searchTextEditingController;
  static final ServicesController controller = ServicesController();
  static final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _duration = duration ?? const Duration(milliseconds: 500);
    final _searchFieldHeight = searchFieldHeight ?? 48;
    final _hPadding = horizontalPadding != null ? horizontalPadding! * 2 : 16;
    final _searchBarWidth =
        searchBarWidth ?? MediaQuery.of(context).size.width - _hPadding;
    final _isBackButtonVisible = isBackButtonVisible ?? false;
    return AnimatedBuilder(
      animation: Listenable.merge([controller]),
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? 8,
              vertical: verticalPadding ?? 8),
          child: SizedBox(
            width: _searchBarWidth,
            height: searchBarHeight ?? 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// back Button
                _isBackButtonVisible
                    ? AnimatedOpacity(
                        opacity: controller.isSearching ? 0 : 1,
                        duration: _duration,
                        child: AnimatedContainer(
                            curve: Curves.easeInOutCirc,
                            width: controller.isSearching ? 0 : 35,
                            height: controller.isSearching ? 0 : 35,
                            duration: _duration,
                            child: FittedBox(
                                child: KBackButton(
                                    icon: backIcon,
                                    iconColor: backIconColor,
                                    previousScreen: previousScreen))))
                    : AnimatedContainer(
                        curve: Curves.easeInOutCirc,
                        width: controller.isSearching ? 0 : 20,
                        height: controller.isSearching ? 0 : 20,
                        duration: _duration),

                /// text
                AnimatedOpacity(
                  opacity: controller.isSearching ? 0 : 1,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    width: controller.isSearching ? 0 : _searchBarWidth - 100,
                    duration: _duration,
                    alignment: isRTL(searchTextEditingController.text, context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        title ?? AppLocalizations.of(context)!.title,
                        textAlign: TextAlign.center,
                        style: titleStyle ??
                            Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  onEnd: () {
                    controller.isSearching
                        ? focusNode.requestFocus()
                        : focusNode.unfocus();
                  },
                ),

                /// close search
                AnimatedOpacity(
                  opacity: controller.isSearching ? 1 : 0,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    width: controller.isSearching ? 35 : 0,
                    height: controller.isSearching ? 35 : 0,
                    duration: _duration,
                    child: FittedBox(
                      child: KCustomButton(
                        widget: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(Icons.close,
                                color: closeIconColor ??
                                    Theme.of(context).errorColor)),
                        onPressed: () {
                          controller.setIsSearching(false);
                          searchTextEditingController.clear();
                          focusNode.unfocus();
                        },
                      ),
                    ),
                  ),
                ),

                /// input panel
                AnimatedOpacity(
                  opacity: controller.isSearching ? 1 : 0,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    duration: _duration,
                    width: controller.isSearching
                        ? _searchBarWidth - 55 - (horizontalPadding ?? 0 * 2)
                        : 0,
                    height: controller.isSearching ? _searchFieldHeight : 20,
                    margin: EdgeInsets.only(
                        left: controller.isSearching ? 5 : 0,
                        right: controller.isSearching ? 10 : 0),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: searchFieldDecoration ??
                        BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: .5,
                          ),
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                    child: TextField(
                      textAlign:
                          isRTL(searchTextEditingController.text, context)
                              ? TextAlign.right
                              : TextAlign.left,
                      controller: searchTextEditingController,
                      cursorColor: cursorColor ??
                          Theme.of(context).scaffoldBackgroundColor,
                      cursorHeight: 24,
                      style: textStyle ??
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText:
                            hintText ?? AppLocalizations.of(context)!.search,
                        hintStyle: hintStyle ??
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.7),
                                fontWeight: FontWeight.normal),
                        disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                      onChanged: onChanged,
                      focusNode: focusNode,
                    ),
                  ),
                ),

                ///  search button
                AnimatedOpacity(
                  opacity: controller.isSearching ? 0 : 1,
                  duration: _duration,
                  child: AnimatedContainer(
                    curve: Curves.easeInOutCirc,
                    duration: _duration,
                    width: controller.isSearching ? 0 : 35,
                    height: controller.isSearching ? 0 : 35,
                    child: FittedBox(
                        child: KCustomButton(
                      widget: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.search,
                              size: 35,
                              color: searchIconColor ??
                                  Theme.of(context).colorScheme.primary)),
                      onPressed: () async {
                        controller.setIsSearching(true);
                      },
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class KCustomButton extends StatelessWidget {
  final Widget widget;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final double? radius;

  const KCustomButton(
      {Key? key,
      required this.widget,
      required this.onPressed,
      this.radius,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 50),
        child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius ?? 50),
            child: InkWell(
                splashColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.2),
                highlightColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.05),
                onTap: onPressed,
                onLongPress: onLongPress,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: widget))));
  }
}

class KBackButton extends StatelessWidget {
  final Widget? previousScreen;
  final Color? iconColor;
  final IconData? icon;

  const KBackButton(
      {Key? key,
      required this.previousScreen,
      required this.iconColor,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
                splashColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.2),
                highlightColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.05),
                onTap: () async {
                  previousScreen == null
                      ? Navigator.pop(context)
                      : Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => previousScreen!));
                },
                child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(icon ?? Icons.arrow_back_rounded,
                            color: iconColor ??
                                Theme.of(context).colorScheme.primary,
                            size: 25))))));
  }
}
