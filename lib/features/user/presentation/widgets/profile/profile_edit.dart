import 'dart:io';

import 'package:ebn_balady/features/user/presentation/manager/user_bloc.dart';
import 'package:ebn_balady/features/user/presentation/widgets/profile/basic_info.dart';
import 'package:ebn_balady/features/user/presentation/widgets/profile/other_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../../../core/widgets/primary_text_field.dart';
import '../../../data/models/user_model.dart';
import '../../pages/profile/edit_profile.dart';

class ProfielEditWidget extends StatefulWidget {
  ProfielEditWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  State<ProfielEditWidget> createState() => _ProfielEditWidgetState();
}

class _ProfielEditWidgetState extends State<ProfielEditWidget> {
  String? countrySelectedValue;
  String? citySelectedValue;
  String? districtSelectedValue;
  late List<String>? phoneList;
  List<TextEditingController>? phoneListControllers = <TextEditingController>[];
  File? imageFile;
  late TextEditingController firstNameController,
      middleNameController,
      lastNameController,
      usernameController,
      neighborhoodController;

  @override
  void initState() {
    EditProfileScreen.edited = false;
    firstNameController = TextEditingController(text: widget.user.firstName);
    middleNameController = TextEditingController(text: widget.user.middleName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    usernameController = TextEditingController(text: widget.user.username);
    neighborhoodController =
        TextEditingController(text: widget.user.neighborhood);

    firstNameController.addListener(() {
      EditProfileScreen.edited = true;
    });
    middleNameController.addListener(() {
      EditProfileScreen.edited = true;
    });
    lastNameController.addListener(() {
      EditProfileScreen.edited = true;
    });
    usernameController.addListener(() {
      EditProfileScreen.edited = true;
    });
    neighborhoodController.addListener(() {
      EditProfileScreen.edited = true;
    });

    countrySelectedValue = widget.user.country ?? "";
    citySelectedValue = widget.user.city ?? "";
    districtSelectedValue = widget.user.district ?? "";
    phoneList = widget.user.phones;
    phoneList?.forEach((element) =>
        phoneListControllers?.add(TextEditingController(text: element)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool quit = false;
        if (EditProfileScreen.edited) {
          Dialogs.bottomMaterialDialog(
              msg: AppLocalizations.of(context)!.sureYouWantToQuit,
              msgStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
              title: AppLocalizations.of(context)!.youWillLoseChanges,
              titleStyle: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
              color: Theme.of(context).colorScheme.surface,
              context: context,
              customView: Icon(
                Icons.drag_handle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
              onClose: (value) => print("returned value is '$value'"),
              actions: [
                IconsOutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: AppLocalizations.of(context)!.cancel,
                  iconData: Icons.cancel_outlined,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                  iconColor: Theme.of(context).colorScheme.onSurface,
                ),
                IconsButton(
                  onPressed: () {
                    phoneListControllers?.clear();
                    EditProfileScreen.edited = false;
                    Get.back();
                    BlocProvider.of<UserBloc>(context)
                        .add(SwitchToViewProfile());
                    Get.back();
                  },
                  text: AppLocalizations.of(context)!.quit,
                  iconData: Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
        } else {
          print("no no nio");
          quit = true;
        }
        if (quit) {
          EditProfileScreen.edited = false;
          BlocProvider.of<UserBloc>(context).add(SwitchToViewProfile());
        }
        return quit;
      },
      child: Scaffold(
        body: CupertinoScrollbar(
          thumbVisibility: true,
          thicknessWhileDragging: 8,
          thickness: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                          child: BasicInfo(
                        user: widget.user,
                        editMode: true,
                        firstNameController: firstNameController,
                        middleNameController: middleNameController,
                        lastNameController: lastNameController,
                        usernameController: usernameController,
                        onImageChanged: (value) {
                          imageFile = value;
                          EditProfileScreen.edited = true;
                        },
                      )),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.phone,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text(
                              AppLocalizations.of(context)!.phoneNumberNumbers,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Center(
                        child: AppTextFormField(
                          context: context,
                          onChanged: (value) {
                            setState(() {
                              EditProfileScreen.edited = true;
                            });
                          },
                          hintText:
                              AppLocalizations.of(context)!.addPhoneNumber,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5)),
                          controller: phoneListControllers?[index],
                          // initialValue: phoneList?[index] ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () {
                              setState(() {
                                phoneListControllers?.removeAt(index);
                                EditProfileScreen.edited = true;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    childCount: phoneListControllers?.length ?? 0,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              phoneListControllers
                                  ?.add(TextEditingController(text: ''));
                              EditProfileScreen.edited = true;
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: Text(
                              AppLocalizations.of(context)!.addPhoneNumber)),
                      const Divider(
                        indent: 64,
                        endIndent: 64,
                      ),
                      OtherInfo(
                        editMode: true,
                        neighborhoodController: neighborhoodController,
                        user: widget.user,
                        onCityChanged: (value) {
                          if (value != null) {
                            citySelectedValue = value;
                            EditProfileScreen.edited = true;
                          }
                        },
                        onCountryChanged: (value) {
                          if (value != null) {
                            countrySelectedValue = value;
                            EditProfileScreen.edited = true;
                          }
                        },
                        onDistrictChanged: (value) {
                          if (value != null) {
                            districtSelectedValue = value;
                            EditProfileScreen.edited = true;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              saveProfileData();
            },
            child: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
            )),
      ),
    );
  }

  void saveProfileData() {
    List<String>? filteredPhoneList = [];
    phoneListControllers?.forEach((a) {
      if (a.text.isNotEmpty) {
        filteredPhoneList.add(a.text);
      }
    });
    print("phones without filters length is ${phoneList?.length}");

    final UserModel user = UserModel(
        firstName: firstNameController.text,
        middleName: middleNameController.text,
        lastName: lastNameController.text,
        neighborhood: neighborhoodController.text,
        phones: filteredPhoneList,
        username: usernameController.text,
        avatar: imageFile ?? widget.user.avatar);
    print("ImageFil $imageFile");
    print("user inside edit is $user");
    print("firstname is ${firstNameController.text}");
    print("middleName is ${middleNameController.text}");
    print("lastName is ${lastNameController.text}");
    print("district is $districtSelectedValue");
    print("city is $citySelectedValue");
    print("country is $countrySelectedValue");
    print("username is ${usernameController.text}");
    print("neighborhood is ${neighborhoodController.text}");
    print("phones length is ${filteredPhoneList.length}");
    print("Phones are $phoneListControllers");
    print("Filtered phones are $filteredPhoneList");
    BlocProvider.of<UserBloc>(context).add(UpdateProfileRequest(user: user));
    EditProfileScreen.edited = false;
    Get.back();
  }
}
