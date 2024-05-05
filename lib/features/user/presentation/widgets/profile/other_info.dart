import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/utils/common_utils.dart';
import '../../../../../core/widgets/primary_text_field.dart';
import '../../../data/models/user_model.dart';
import '../details_dropdown_field.dart';

class OtherInfo extends StatefulWidget {
  OtherInfo({
    required this.editMode,
    this.neighborhoodController,
    Key? key,
    required this.user,
    this.onCountryChanged,
    this.onCityChanged,
    this.onDistrictChanged,
  }) : super(key: key);
  final bool editMode;
  final UserModel user;
  final ValueChanged<String?>? onCountryChanged,
      onCityChanged,
      onDistrictChanged;
  TextEditingController? neighborhoodController;

  @override
  State<OtherInfo> createState() => _OtherInfoState();
}

class _OtherInfoState extends State<OtherInfo> {
  String? countryValue;

  String? cityValue;

  String? districtValue;
  @override
  void initState() {
    widget.neighborhoodController?.text = widget.user.neighborhood ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.place_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            if (!widget.editMode)
              Expanded(
                flex: 3,
                child: Text(
                  AppLocalizations.of(context)!.country,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: widget.editMode ? 8 : 3,
              child: widget.editMode
                  ? AppDropDownField(
                      context: context,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      items: getCountries(context),
                      hint: AppLocalizations.of(context)!.selectCountry,
                      initialValue: countryValue,
                      onChanged: (districtSelectedValue) {
                        if (widget.onCountryChanged != null) {
                          widget.onCountryChanged!(
                              districtSelectedValue.toString());
                        }
                      },
                      validator: (value) => value == null
                          ? AppLocalizations.of(context)!.pleaseSelectCountry
                          : null,
                    )
                  : Text(
                      widget.user.country ?? "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
            ),
          ],
        ),
        const Divider(
          indent: 64,
          endIndent: 64,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.location_city_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            if (!widget.editMode)
              Expanded(
                flex: 3,
                child: Text(
                  AppLocalizations.of(context)!.city,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: widget.editMode ? 8 : 3,
              child: widget.editMode
                  ? AppDropDownField(
                      context: context,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      items: getCities(context),
                      hint: AppLocalizations.of(context)!.selectCity,
                      initialValue: districtValue,
                      onChanged: (citySelectedValue) {
                        if (widget.onCityChanged != null) {
                          widget.onCityChanged!(citySelectedValue.toString());
                        }
                      },
                      validator: (value) => value == null
                          ? AppLocalizations.of(context)!.pleaseSelectCity
                          : null,
                    )
                  : Text(
                      widget.user.city ?? "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
            ),
          ],
        ),
        const Divider(
          indent: 64,
          endIndent: 64,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.maps_home_work_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            if (!widget.editMode)
              Expanded(
                flex: 3,
                child: Text(
                  AppLocalizations.of(context)!.district,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: widget.editMode ? 8 : 3,
              child: widget.editMode
                  ? AppDropDownField(
                      context: context,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      items: getDistricts(context),
                      hint: AppLocalizations.of(context)!.selectDistrict,
                      initialValue: districtValue,
                      onChanged: (districtSelectedValue) {
                        if (widget.onDistrictChanged != null) {
                          widget.onDistrictChanged!(
                              districtSelectedValue.toString());
                        }
                      },
                      validator: (value) => value == null
                          ? AppLocalizations.of(context)!.pleaseSelectDistrict
                          : null,
                    )
                  : Text(
                      widget.user.district ?? "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
            ),
          ],
        ),
        const Divider(
          indent: 64,
          endIndent: 64,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.home_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            !widget.editMode
                ? Expanded(
                    flex: 3,
                    child: Text(
                      AppLocalizations.of(context)!.neighborhood,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                : const SizedBox(),
            widget.editMode
                ? Expanded(
                    flex: 7,
                    child: AppTextFormField(
                      context: context,
                      controller: widget.neighborhoodController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      hintText: AppLocalizations.of(context)!.yourNeighborhood,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5)),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                      suffixIcon: const Icon(Icons.edit),
                    ))
                : Expanded(
                    flex: 3,
                    child: Text(
                      widget.user.neighborhood ?? "",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
          ],
        ),
        const SizedBox(
          height: 48,
        ),
      ],
    );
  }
}
