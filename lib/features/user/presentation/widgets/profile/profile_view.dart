import 'package:ebn_balady/core/models/current_provider.dart';
import 'package:ebn_balady/features/user/presentation/widgets/profile/basic_info.dart';
import 'package:ebn_balady/features/user/presentation/widgets/profile/other_info.dart';
import 'package:ebn_balady/features/user/presentation/widgets/profile/progress.dart';
import 'package:ebn_balady/features/user/presentation/widgets/profile/review.dart';
import 'package:ebn_balady/features/user/presentation/widgets/profile/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../manager/user_bloc.dart';

class ProfileViewWidget extends StatefulWidget {
  ProfileViewWidget({Key? key, required this.state, this.other})
      : super(key: key);

  final state;
  bool? other;

  @override
  State<ProfileViewWidget> createState() => _ProfileViewWidgetState();
}

class _ProfileViewWidgetState extends State<ProfileViewWidget> {
  bool isFriend = false;

  Future<void> _onRefresh(BuildContext context) async {
    if (widget.other ?? true) {
      BlocProvider.of<UserBloc>(context)
          .add(GetUserRequest(userId: widget.state.user.id!));
    } else {
      BlocProvider.of<UserBloc>(context).add(const GetMyProfileData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: CupertinoScrollbar(
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
                      user: widget.state.user,
                      editMode: false,
                    )),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                        child: Statistics(
                      user: widget.state.user,
                    )),
                    Center(
                        child: ReviewSection(
                      user: widget.state.user,
                    )),
                    if ((widget.other ?? false) &&
                        Current.user.id != widget.state.user.id)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.message,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.place),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isFriend = !isFriend;
                                });
                              },
                              icon: isFriend
                                  ? Icon(
                                      Icons.person,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : Icon(
                                      Icons.person_add,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    )),
                        ],
                      ),
                    Progress(
                      user: widget.state.user,
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                      child: ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.call_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          widget.state.user.phones?[index] ?? '0',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    );
                  },
                  childCount: widget.state.user.phones?.length ?? 0,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Divider(
                      indent: 64,
                      endIndent: 64,
                    ),
                    OtherInfo(
                      editMode: false,
                      user: widget.state.user,
                    ),
                    const SizedBox(
                      height: 96,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
