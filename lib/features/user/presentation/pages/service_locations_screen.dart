import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../core/constants.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/error_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../injection_container.dart';
import '../../data/models/direction_model.dart';
import '../../data/models/service_point_model.dart';
import '../manager/user_bloc.dart';
import '../widgets/service_point_preview.dart';
import '../widgets/service_points_loading_widget.dart';

class ServiceLocationsScreen extends StatefulWidget {
  const ServiceLocationsScreen({Key? key}) : super(key: key);

  @override
  _ServiceLocationsScreenState createState() => _ServiceLocationsScreenState();
}

class _ServiceLocationsScreenState extends State<ServiceLocationsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? selectedLocation;
  LatLng? userLocation;
  DirectionModel? direction;
  bool directionsLoading = false;

  static const CameraPosition initialLocation = CameraPosition(
    target: LatLng(15.3694, 44.1910),
    zoom: 12.0,
  );

  @override
  void initState() {
    _findNearestServicePointOrCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (direction != null) {
          setState(() {
            direction = null;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.agentsAndMerchantLocations),
        ),
        body: BlocProvider(
          create: (context) => sl<UserBloc>(),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (_context, state) async {
              logger.d('state in listener is $state');
              if (state is UserError) {
                await showFlushBar(state.message, context: context)
                    .then((value) {
                  Get.back();
                });
                setState(() {
                  directionsLoading = false;
                });
              }
              if (state is DirectionNotFound) {
                await showFlushBar(
                    AppLocalizations.of(context)!.noDirectionsFound,
                    info: true,
                    context: context);
                setState(() {
                  directionsLoading = false;
                  direction = null;
                });
              }
              if (state is DirectionLoading) {
                setState(() {
                  directionsLoading = true;
                });
              }
              if (state is DirectionLoaded) {
                setState(() {
                  direction = state.direction;
                  directionsLoading = false;
                });
                if (userLocation != null) {
                  await animateTo(
                      userLocation!.latitude, userLocation!.longitude,
                      zoom: 18);
                }
              }
            },
            buildWhen: (oldState, newState) {
              if (newState is DirectionLoaded ||
                  newState is DirectionLoading ||
                  newState is DirectionNotFound) {
                return false;
              }
              return true;
            },
            builder: (_context, state) {
              ScreenUtil().init(context);
              if (state is UserInitial) {
                BlocProvider.of<UserBloc>(_context)
                    .add(const GetServicePoints());
                return const SizedBox();
              }
              if (state is ServicePointsLoading) {
                return const ServicePointsLoadingWidget();
              }
              if (state is ServicePointsLoaded) {
                return Stack(
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
                            buildingsEnabled: false,
                            myLocationEnabled: true,
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(6.0, 22.0),
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
                            markers:
                                state.servicePoints.all.map((servicePoint) {
                              return Marker(
                                markerId: MarkerId(servicePoint.id!.toString()),
                                icon: servicePoint.isMerchantPoint
                                    ? BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueAzure)
                                    : BitmapDescriptor.defaultMarker,
                                position: LatLng(servicePoint.latitude!,
                                    servicePoint.longitude!),
                                infoWindow:
                                    InfoWindow(title: servicePoint.name),
                                draggable: false,
                                onTap: () async {
                                  bool shouldShowDirectionsToPoints =
                                      await ServicePointPreview.show(
                                          servicePoint: servicePoint,
                                          userLocationAvailable:
                                              userLocation != null);
                                  if (shouldShowDirectionsToPoints) {
                                    setState(() {
                                      direction = null;
                                    });

                                    showDirectionsToPoints(
                                      blocContext: _context,
                                      origin: LatLng(userLocation!.latitude,
                                          userLocation!.longitude),
                                      destination: LatLng(
                                          servicePoint.latitude!,
                                          servicePoint.longitude!),
                                      // destination: const LatLng(15.4074824, 44.1399677),
                                    );
                                  }
                                },
                              );
                            }).toSet(),
                            polylines: {
                              if (direction != null)
                                Polyline(
                                  polylineId:
                                      const PolylineId('overview_polyline'),
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 5,
                                  points: direction!.polylinePoints
                                      .map((e) =>
                                          LatLng(e.latitude, e.longitude))
                                      .toList(),
                                ),
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: ScreenUtil.screenHeightNoPadding - 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          PrimaryButton(
                              text: AppLocalizations.of(context)!
                                  .findNearestAgent,
                              onTap: () {
                                _findNearestServicePointOrCurrentLocation(
                                    servicePoints:
                                        state.servicePoints.agentPoints);
                              }),
                          const SizedBox(
                            height: 12,
                          )
                        ],
                      ),
                    ),
                    if (directionsLoading) ...[
                      Container(
                        height: ScreenUtil.screenHeightNoPadding,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.9),
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)!.loadingDirections,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                        )),
                      )
                    ],
                    if (direction != null) ...[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(8),
                          child: Text(
                            AppLocalizations.of(context)!.distanceAndDuration(
                                direction!.totalDistance,
                                direction!.totalDuration),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ]
                  ],
                );
              }
              if (state is UserError) {
                return Center(
                  child: ErrorCard(
                    message: state.message,
                    generalError: true,
                    onRefresh: () {
                      // _findNearestServicePointOrCurrentLocation();
                      BlocProvider.of<UserBloc>(_context)
                          .add((const GetServicePoints()));
                    },
                    fullHeight: true,
                  ),
                );
              }
              return Center(
                child: ErrorCard(
                  message: AppLocalizations.of(context)!.unexpectedError,
                  generalError: true,
                  onRefresh: () {
                    // _findNearestServicePointOrCurrentLocation();
                    BlocProvider.of<UserBloc>(_context)
                        .add((const GetServicePoints()));
                  },
                  fullHeight: true,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _findNearestServicePointOrCurrentLocation(
      {List<ServicePointModel>? servicePoints}) async {
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
      await showFlushBar(
          AppLocalizations.of(context)!.pleaseAllowRequiredPermissions,
          info: true,
          context: context);
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        await showFlushBar(
            AppLocalizations.of(context)!.pleaseAllowRequiredPermissions,
            info: true,
            context: context);
        return;
      }
    }
    await location.getLocation().then((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          userLocation = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );

          if (servicePoints != null) {
            if (servicePoints.isEmpty) {
              showFlushBar(AppLocalizations.of(context)!.seemsNoAgentsAround,
                  info: true, context: context);
              return;
            }
            List<double> distances = servicePoints
                .map((point) => calculateDistance(
                      userLocation!.latitude,
                      userLocation!.longitude,
                      point.latitude,
                      point.longitude,
                    ))
                .toList();

            ServicePointModel nearestServicePoint = servicePoints
                .elementAt(distances.indexOf(distances.reduce(min)));

            if (nearestServicePoint.latitude != null &&
                nearestServicePoint.longitude != null) {
              animateTo(nearestServicePoint.latitude!,
                  nearestServicePoint.longitude!);
            }
          } else {
            animateTo(userLocation!.latitude, userLocation!.longitude);
          }
        });
      }
    });
  }

  Future<void> animateTo(double lat, double lng, {double zoom = 14.0}) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: zoom);
    await c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void showDirectionsToPoints(
      {required BuildContext blocContext,
      required LatLng origin,
      required LatLng destination}) async {
    try {
      launchMap(
          origin: LatLng(origin.latitude, origin.longitude),
          destination: LatLng(destination.latitude, destination.longitude));
    } catch (e) {
      if (billingEnabledInProject) {
        BlocProvider.of<UserBloc>(blocContext)
            .add((GetDirections(origin: origin, destination: destination)));
      } else {
        await showFlushBar(AppLocalizations.of(Get.context!)!.noDirectionsFound,
            context: context);
      }
    }
  }
}
