import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/primary_text_field.dart';
import '../../../data/models/user_model.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({
    required this.editMode,
    required this.user,
    this.firstNameController,
    this.middleNameController,
    this.lastNameController,
    this.usernameController,
    Key? key,
    this.onImageChanged,
  }) : super(key: key);
  final bool editMode;
  final UserModel user;
  final ValueChanged<File?>? onImageChanged;
  final TextEditingController? firstNameController,
      middleNameController,
      lastNameController,
      usernameController;

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  File? fileImage;

  @override
  void initState() {
    widget.firstNameController?.text = widget.user.firstName ?? "";
    widget.middleNameController?.text = widget.user.middleName ?? "";
    widget.lastNameController?.text = widget.user.lastName ?? "";
    widget.usernameController?.text = widget.user.username ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.editMode) {
              await _showMyDialog();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.editMode
                  ? CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 64,
                      backgroundImage: fileImage != null
                          ? FileImage(
                              fileImage!,
                            )
                          : null,
                      child: fileImage == null ? const Icon(Icons.image) : null,
                    )
                  : CachedNetworkImage(
                      width: 120,
                      imageUrl: widget.user.avatar ?? "",
                      errorWidget: (context, url, error) => Icon(
                        Icons.account_circle,
                        size: 120,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
              if (!widget.editMode)
                SizedBox(
                  width: 124,
                  height: 124,
                  child: CircularProgressIndicator(
                    value: widget.user.statistics?.progress ?? 0.0,
                    strokeWidth: 4,
                    color: AppTheme.gold,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                  ),
                ),
              widget.editMode
                  ? fileImage != null
                      ? Positioned(
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                          ),
                        )
                      : const SizedBox()
                  : Positioned(
                      right: 8,
                      bottom: 4,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: Text(
                            "${((widget.user.statistics?.progress ?? 0) * 100).toInt()}%",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                      ))
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        widget.editMode
            ? Column(
                children: [
                  AppTextFormField(
                    context: context,
                    controller: widget.firstNameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    hintText: AppLocalizations.of(context)!.yourFirstName,
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5)),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                    suffixIcon: const Icon(Icons.edit),
                  ),
                  AppTextFormField(
                    context: context,
                    controller: widget.middleNameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    hintText: AppLocalizations.of(context)!.yourMiddleName,
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5)),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                    suffixIcon: const Icon(Icons.edit),
                  ),
                  AppTextFormField(
                    context: context,
                    controller: widget.lastNameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    hintText: AppLocalizations.of(context)!.yourLastName,
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5)),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                    suffixIcon: const Icon(Icons.edit),
                  ),
                ],
              )
            : Text(
                "${widget.user.firstName ?? ""} ${widget.user.middleName ?? ""} ${widget.user.lastName ?? ""}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
        widget.editMode
            ? AppTextFormField(
                context: context,
                controller: widget.usernameController,
                onChanged: (value) {
                  setState(() {});
                },
                hintText: AppLocalizations.of(context)!.yourUsername,
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5)),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
                suffixIcon: const Icon(Icons.edit),
              )
            : Text(
                widget.user.username ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              )
      ],
    );
  }

  Future pickImage(source) async {
    Navigator.pop(context, 'Dismiss');
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);
      setState(() {
        fileImage = imageTemporary;
        widget.onImageChanged!(fileImage);
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed');
      }
    }
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
}
