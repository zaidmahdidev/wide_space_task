import 'dart:developer';

import 'package:ebn_balady/features/user/presentation/manager/user_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/models/current_provider.dart';
import '../../../../../core/utils/common_utils.dart';
import '../../../../../core/widgets/error_card.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/profile/profile_view.dart';
import '../../widgets/profile/user_shimmer.dart';

class ViewProfileScreen extends StatefulWidget {
  ViewProfileScreen({
    this.other = true,
    required this.user,
    Key? key,
  }) : super(key: key);
  bool other;
  final UserModel user;

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.other) {
      return WillPopScope(
        onWillPop: () async {
          BlocProvider.of<UserBloc>(context).add(const GetMyProfileData());
          return true;
        },
        child: Scaffold(
          body: NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    BlocProvider.of<UserBloc>(context)
                        .add(const GetMyProfileData());
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                snap: true,
                floating: true,
                centerTitle: false,
              ),
            ],
            body: buildProfile(context),
          ),
        ),
      );
    }
    return buildProfile(context);
  }

  BlocProvider<UserBloc> buildProfile(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<UserBloc>(context),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (kDebugMode) {
            log("state in profile is $state");
          }
          if (state is UserError) {
            showFlushBar(
              state.message,
              context: context,
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoaded || state is LoginLoaded) {
            return ProfileViewWidget(
              state: state,
              other: widget.other,
            );
          } else if (state is UserLoading) {
            return UserShimmer(
              other: widget.other,
            );
          } else if (state is UserError) {
            if (widget.other) {
              return ErrorCard(
                onRefresh: () async {
                  BlocProvider.of<UserBloc>(context)
                      .add(GetUserRequest(userId: widget.user.id!));
                },
                message: state.message,
              );
            } else {
              return ProfileViewWidget(
                state: UserLoaded(user: Current.user),
                other: false,
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
