import 'package:dropdown_search/dropdown_search.dart';
import 'package:ebn_balady/features/posts/data/repositories/posts_repository.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../../../core/app_theme.dart';
import '../../../../injection_container.dart';
import '../../../user/data/models/user_model.dart';
import '../../data/models/data_temp/choice_chips.dart';
import '../../data/models/data_temp/filter_chips.dart';
import '../../data/models/data_temp/input_chips.dart';
import '../../data/models/filters/choice_chip_data.dart';
import '../../data/models/filters/filter_chip_data.dart';
import '../../data/models/filters/input_chip_data.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<InputChipData> inputChips = InputChips.all;
  List<FilterChipData> filterChips = FilterChips.all;
  List<ChoiceChipData> choiceChips = ChoiceChips.filtersList;
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();

  final double spacing = 8;
  bool isAllPosts = true;
  bool isFilteredWithOptions = false;
  bool isFilteredWithLabels = false;
  bool isFilteredWithPeople = false;
  bool isFilteredWithDate = false;
  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MMM-dd');
  bool isFromDateSelected = false, isToDateSelected = false;
  final _userEditTextController = TextEditingController(text: 'Mrs');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Theme.of(context).shadowColor,
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            iconColor: (isFilteredWithOptions ||
                    isFilteredWithLabels ||
                    isFilteredWithPeople ||
                    isFilteredWithDate)
                ? Theme.of(context).toggleableActiveColor
                : Theme.of(context).colorScheme.onSurface,
          ),
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Filters',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: (isFilteredWithOptions ||
                            isFilteredWithLabels ||
                            isFilteredWithPeople ||
                            isFilteredWithDate)
                        ? Theme.of(context).toggleableActiveColor
                        : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          collapsed: const SizedBox(),
          expanded: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, -4),
                  blurRadius: 16,
                  color: Theme.of(context).shadowColor,
                  inset: true,
                ),
                BoxShadow(
                  offset: const Offset(-4, 0),
                  blurRadius: 16,
                  color: Theme.of(context).shadowColor,
                  inset: true,
                ),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              buildChoiceChips(),
              const Divider(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.topics,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  Expanded(child: buildFilterChips()),
                ],
              ),
              const Divider(),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.from,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      isFromDateSelected
                          ? Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      formatter.format(_selectedFromDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .toggleableActiveColor),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isFromDateSelected = false;
                                          isFilteredWithDate =
                                              isFromDateSelected ||
                                                  isToDateSelected;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      )),
                                ],
                              ),
                            )
                          : Expanded(
                              flex: 2,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.date_range),
                                onPressed: () {
                                  Dialogs.bottomMaterialDialog(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      context: context,
                                      customView: SizedBox(
                                        height: 250,
                                        child: ScrollDatePicker(
                                          selectedDate: _selectedFromDate,
                                          locale: Get.locale,
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              _selectedFromDate = value;
                                            });
                                          },
                                        ),
                                      ),
                                      onClose: (value) =>
                                          print("returned value is '$value'"),
                                      actions: [
                                        IconsOutlineButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          text: AppLocalizations.of(context)!
                                              .cancel,
                                          iconData: Icons.cancel_outlined,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                          iconColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            setState(() {
                                              isFromDateSelected = true;
                                              isFilteredWithDate =
                                                  isFromDateSelected ||
                                                      isToDateSelected;
                                            });
                                            Get.back();
                                          },
                                          text: AppLocalizations.of(context)!
                                              .done,
                                          iconData: Icons.check,
                                          color: Get.isDarkMode
                                              ? AppTheme.darkSuccessColor
                                              : AppTheme.successColor,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                },
                                label: Text(
                                    AppLocalizations.of(context)!.pickDate),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.to,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      isToDateSelected
                          ? Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    formatter.format(_selectedToDate),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .toggleableActiveColor),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isToDateSelected = false;
                                          isFilteredWithDate =
                                              isFromDateSelected ||
                                                  isToDateSelected;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      )),
                                ],
                              ),
                            )
                          : Expanded(
                              flex: 2,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.date_range),
                                label: Text(
                                    AppLocalizations.of(context)!.pickDate),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  Dialogs.bottomMaterialDialog(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      context: context,
                                      customView: SizedBox(
                                        height: 250,
                                        child: ScrollDatePicker(
                                          selectedDate: _selectedToDate,
                                          locale: Get.locale,
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              _selectedToDate = value;
                                            });
                                          },
                                        ),
                                      ),
                                      onClose: (value) =>
                                          print("returned value is '$value'"),
                                      actions: [
                                        IconsOutlineButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          text: AppLocalizations.of(context)!
                                              .cancel,
                                          iconData: Icons.cancel_outlined,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                          iconColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            setState(() {
                                              isToDateSelected = true;
                                              isFilteredWithDate =
                                                  isFromDateSelected ||
                                                      isToDateSelected;
                                            });
                                            Get.back();
                                          },
                                          text: AppLocalizations.of(context)!
                                              .done,
                                          iconData: Icons.check,
                                          color: Get.isDarkMode
                                              ? AppTheme.darkSuccessColor
                                              : AppTheme.successColor,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                },
                              ),
                            )
                    ],
                  )
                ],
              ),
              const Divider(),
              buildInputChips(),
              DropdownSearch<UserModel>.multiSelection(
                asyncItems: (filter) => getData(filter),
                itemAsString: (UserModel u) => u.displayName,
                compareFn: (i, s) => i.id == s.id,
                clearButtonProps: ClearButtonProps(
                    isVisible: true,
                    color: Theme.of(context).colorScheme.error),
                dropdownButtonProps: DropdownButtonProps(
                  icon: Icon(Icons.filter_alt_outlined,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.filterByPeople,
                    hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    showSearchBox: true,
                    scrollbarProps: ScrollbarProps(
                        thumbColor: Theme.of(context).colorScheme.primary),
                    searchFieldProps: TextFieldProps(
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        hintText: AppLocalizations.of(context)!.search,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.6)),
                        errorStyle:
                            Theme.of(context).inputDecorationTheme.errorStyle,
                        border: OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    modalBottomSheetProps: ModalBottomSheetProps(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    itemBuilder: _customPopupItemBuilderExample2,
                    fit: FlexFit.loose),
              ),
              const Divider(),
              Row(
                children: const [
                  Text('Dropdown with order'),
                  Text('Dropdown with keys'),
                ],
              ),
              // Row(
              //   children: [
              //     DropdownSearch<String>(
              //       popupProps: PopupProps.menu(
              //         showSelectedItems: true,
              //         disabledItemFn: (String s) => s.startsWith('I'),
              //       ),
              //       items: const [
              //         "Brazil",
              //         "Italia (Disabled)",
              //         "Tunisia",
              //         'Canada'
              //       ],
              //       dropdownDecoratorProps: const DropDownDecoratorProps(
              //         dropdownSearchDecoration: InputDecoration(
              //           labelText: "Menu mode",
              //           hintText: "country in menu mode",
              //         ),
              //       ),
              //       onChanged: print,
              //       selectedItem: "Brazil",
              //     ),
              //     DropdownSearch<String>.multiSelection(
              //       items: const [
              //         "Brazil",
              //         "Italia (Disabled)",
              //         "Tunisia",
              //         'Canada'
              //       ],
              //       popupProps: PopupPropsMultiSelection.menu(
              //         showSelectedItems: true,
              //         disabledItemFn: (String s) => s.startsWith('I'),
              //       ),
              //       onChanged: print,
              //       selectedItems: const ["Brazil"],
              //     )
              //   ],
              // ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    final failureOrUsers = await sl.get<PostsRepository>().getUsers(1);
    return failureOrUsers.fold((failure) => <UserModel>[], (users) => users);
    // var response = await Dio().get(
    //   "https://5d85ccfb1e61af001471bf60.mockapi.io/user",
    //   queryParameters: {"filter": filter},
    // );
    //
    // final data = response.data;
    // if (data != null) {
    //   return data;
    // }
    // return [];
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    UserModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        selected: isSelected,
        title: Text(
          item?.displayName ?? '',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        subtitle: Text(
          item?.id.toString() ?? '',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: CircleAvatar(
          radius: 32,
          backgroundColor: Theme.of(context).colorScheme.primary,
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item?.avatar ?? ''),
        ),
      ),
    );
  }

  Widget buildInputChips() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: inputChips
              .map((inputChip) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputChip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      avatar: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: NetworkImage(inputChip.urlAvatar),
                      ),
                      label: Text(inputChip.label),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                      onPressed: () => {},
                      onDeleted: () => setState(() {
                        inputChips.remove(inputChip);
                        isFilteredWithPeople = inputChips.isNotEmpty;
                      }),
                    ),
                  ))
              .toList(),
        ),
      );

  bool isAll = true;

  Widget buildChoiceChips() => Wrap(
        runSpacing: spacing,
        spacing: spacing,
        children: ChoiceChips.getPostList(isAll)
            .map((choiceChip) => ChoiceChip(
                  label: Text(choiceChip.label),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                  onSelected: (isSelected) => setState(() {
                    ChoiceChips.getNotificationList(isAll).map((otherChip) {
                      if (choiceChip.label ==
                          AppLocalizations.of(Get.context!)!.mine) {
                        isAll = false;
                        // BlocProvider.of<NotificationBloc>(notificationContext)
                        //     .add(ToUnreadNotifications());
                      } else if (choiceChip.label ==
                          AppLocalizations.of(Get.context!)!.all) {
                        isAll = true;
                        // BlocProvider.of<NotificationBloc>(notificationContext)
                        //     .add(ToAllNotifications());
                      }
                      return otherChip.copy(
                          label: choiceChip.label,
                          isSelected: isSelected,
                          textColor: choiceChip.textColor,
                          selectedColor: choiceChip.selectedColor);
                    }).toList();
                  }),
                  selected: choiceChip.isSelected,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ))
            .toList(),
      );

  Widget buildFilterChips() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filterChips
              .map((filterChip) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterChip(
                      label: Text(filterChip.label),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: filterChip.color,
                      ),
                      backgroundColor: filterChip.color.withOpacity(0.1),
                      onSelected: (isSelected) => setState(() {
                        isFilteredWithLabels = false;

                        filterChips = filterChips.map((otherChip) {
                          if (filterChip == otherChip) {
                            otherChip = otherChip.copy(
                              isSelected: isSelected,
                              label: otherChip.label,
                              color: otherChip.color,
                            );
                          }
                          isFilteredWithLabels =
                              isFilteredWithLabels || otherChip.isSelected;

                          return otherChip;
                        }).toList();
                        setState(() {});
                      }),
                      selected: filterChip.isSelected,
                      checkmarkColor: filterChip.color,
                      selectedColor: filterChip.color.withOpacity(0.25),
                    ),
                  ))
              .toList(),
        ),
      );
}
