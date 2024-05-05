import 'package:ebn_balady/core/models/current_provider.dart';
import 'package:ebn_balady/features/user/presentation/manager/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../../../core/utils/common_utils.dart';
import '../../../../posts/presentation/widgets/form_widget.dart';
import '../../widgets/profile/profile_edit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);
  static bool edited = false;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            leading: IconButton(
              onPressed: () async {
                bool quit = false;
                if (EditProfileScreen.edited) {
                  Dialogs.bottomMaterialDialog(
                      msg: AppLocalizations.of(context)!.sureYouWantToQuit,
                      msgStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                      title: AppLocalizations.of(context)!.youWillLoseChanges,
                      titleStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                      color: Theme.of(context).colorScheme.surface,
                      context: context,
                      customView: Icon(
                        Icons.drag_handle,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
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
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                          iconColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        IconsButton(
                          onPressed: () {
                            FormWidget.edited = false;
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
                  quit = true;
                }
                if (quit) {
                  EditProfileScreen.edited = false;
                  Get.back();
                  BlocProvider.of<UserBloc>(context).add(SwitchToViewProfile());
                }
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            title: Text(AppLocalizations.of(context)!.editProfile),
            backgroundColor: Colors.transparent,
            elevation: 0,
            snap: true,
            floating: true,
            centerTitle: false,
          ),
        ],
        body: buildProfile(context),
      ),
    );
  }

  BlocProvider<UserBloc> buildProfile(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<UserBloc>(context),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            showFlushBar(
              state.message,
              context: context,
            );
          }
        },
        builder: (context, state) {
          if (state is UserEdit) {
            return ProfielEditWidget(
              user: state.user,
            );
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return ProfielEditWidget(
              user: Current.user,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
