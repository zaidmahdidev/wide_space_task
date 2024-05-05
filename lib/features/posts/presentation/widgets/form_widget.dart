import 'dart:io';

import 'package:ebn_balady/features/posts/presentation/states%20manager/posts_bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../../core/widgets/primary_text_field.dart';
import '../../data/models/data_temp/filter_chips.dart';
import '../../data/models/filters/filter_chip_data.dart';
import '../../data/models/post/Post.dart';

class FormWidget extends StatefulWidget {
  FormWidget({Key? key, this.post}) : super(key: key);
  final PostModel? post;
  static bool edited = false;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  File? fileImage;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  List<FilterChipData> filterChips = FilterChips.all;
  final double spacing = 8;

  @override
  void initState() {
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }
    super.initState();
  }

  @override
  void dispose() {
    FormWidget.edited = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool quit = false;
        if (FormWidget.edited) {
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
                    FormWidget.edited = false;
                    Get.back();
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
        return quit;
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await _showMyDialog();
                  },
                  child: Stack(children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 64,
                      backgroundImage: fileImage != null
                          ? FileImage(
                              fileImage!,
                            )
                          : null,
                      child: fileImage == null ? const Icon(Icons.image) : null,
                    ),
                    if (fileImage != null)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  fileImage = null;
                                });
                              },
                              icon: Icon(Icons.hide_image_outlined,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                      )
                    else
                      const SizedBox(),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
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
                                backgroundColor:
                                    filterChip.color.withOpacity(0.1),
                                onSelected: (isSelected) => setState(() {
                                  FormWidget.edited = true;

                                  filterChips = filterChips.map((otherChip) {
                                    if (filterChip == otherChip) {
                                      otherChip = otherChip.copy(
                                        isSelected: isSelected,
                                        label: otherChip.label,
                                        color: otherChip.color,
                                      );
                                    }
                                    return otherChip;
                                  }).toList();
                                }),
                                selected: filterChip.isSelected,
                                checkmarkColor: filterChip.color,
                                selectedColor:
                                    filterChip.color.withOpacity(0.25),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                AppTextFormField(
                  context: context,
                  onChanged: (val) {
                    setState(() {
                      FormWidget.edited = true;
                    });
                  },
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                  controller: _titleController,
                  hintText: AppLocalizations.of(context)!.title,
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.6)),
                ),
                AppTextFormField(
                  context: context,
                  onChanged: (val) {
                    setState(() {
                      FormWidget.edited = true;
                    });
                  },
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                  controller: _bodyController,
                  hintText: AppLocalizations.of(context)!.description,
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.6)),
                  minLines: 3,
                  maxLines: 6,
                ),
                const SizedBox(
                  height: 16,
                ),
                FloatingActionButton.extended(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    _validateAddRequest();
                  },
                  isExtended: true,
                  tooltip: widget.post != null
                      ? AppLocalizations.of(context)!.editRequest
                      : AppLocalizations.of(context)!.addRequest,
                  label: Text(
                    widget.post != null
                        ? AppLocalizations.of(context)!.editRequest
                        : AppLocalizations.of(context)!.addRequest,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.chooseMethod),
          children: [
            SimpleDialogOption(
              onPressed: () => pickImage(ImageSource.gallery),
              child: ListTile(
                leading: Icon(Icons.image),
                title: Text(AppLocalizations.of(context)!.gallery),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => pickImage(ImageSource.camera),
              child: ListTile(
                leading: Icon(Icons.camera_alt_rounded),
                title: Text(AppLocalizations.of(context)!.camera),
              ),
            )
          ],
        );
      },
    );
  }

  void _validateAddRequest() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (widget.post != null) {
        PostModel post = PostModel(
          id: widget.post!.id,
          body: _bodyController.text.trim(),
          title: _titleController.text.trim(),
          image: fileImage,
        );
        print("post inside validation is ${widget.post}");
        BlocProvider.of<PostsBloc>(context).add(UpdatePostEvent(post: post));
      } else {
        final PostModel post = PostModel(
          body: _bodyController.text.trim(),
          title: _titleController.text.trim(),
          image: fileImage,
        );
        BlocProvider.of<PostsBloc>(context).add(AddPostEvent(post: post));
      }
    }
  }

  Future pickImage(source) async {
    Navigator.pop(context, 'Lost');
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);
      setState(() {
        fileImage = imageTemporary;
        FormWidget.edited = true;
      });
    } on PlatformException catch (e) {
      print('Failed');
    }
  }
}
