import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../../core/utils/common_utils.dart';
import '../../../../../core/utils/screen_util.dart';
import '../../../../../core/widgets/primary_button.dart';

class PickLocationPage extends StatefulWidget {
  final LatLng? oldLocation;

  const PickLocationPage({Key? key, this.oldLocation}) : super(key: key);

  @override
  _PickLocationPageState createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? selectedLocation;
  static late CameraPosition initialLocation;

  @override
  void initState() {
    initialLocation = CameraPosition(
      target: widget.oldLocation ?? const LatLng(15.3694, 44.1910),
      zoom: 12.0,
    );
    _getUserLocation(animateToLocation: widget.oldLocation == null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.pickServicePointLocation),
          ),
          body: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                height: ScreenUtil.screenHeightNoPadding,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 16.0,
                        spreadRadius: 16.0)
                  ],
                ),
                child: Stack(
                  children: [
                    GoogleMap(
                      compassEnabled: true,
                      buildingsEnabled: true,
                      myLocationEnabled: true,
                      minMaxZoomPreference:
                          const MinMaxZoomPreference(6.0, 18.0),
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      onCameraMove: (cameraPosition) {
                        setState(() {
                          selectedLocation = LatLng(
                              cameraPosition.target.latitude,
                              cameraPosition.target.longitude);
                        });
                      },
                      initialCameraPosition: initialLocation,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: .8,
                        child: Icon(
                          Icons.pin_drop_rounded,
                          size: sameOnRotate(divideOn: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: ScreenUtil.screenHeightNoPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    PrimaryButton(
                        text: AppLocalizations.of(context)!.chooseThisLocation,
                        onTap: () {
                          Get.back(result: selectedLocation);
                        }),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void _getUserLocation({bool animateToLocation = true}) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    if (animateToLocation) {
      location.getLocation().then((LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            selectedLocation = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );

            animateTo(currentLocation.latitude!, currentLocation.longitude!);
          });
        }
      });
    }
  }

  Future<void> animateTo(double lat, double lng) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.0);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }
}
