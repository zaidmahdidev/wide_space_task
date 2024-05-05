import 'dart:async';

import 'package:ebn_balady/features/map/presentation/widgets/map_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../posts/data/models/data_temp/choice_chips.dart';
import '../../data/models/map_model.dart';
import '../states manager/map_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController searchController = TextEditingController();
  final double spacing = 8;

  bool isListView = true;
  LatLng currentLocation = const LatLng(15.352158616017283, 44.2095);
  final Completer<GoogleMapController> googleMapControllerCompleter =
      Completer();
  late GoogleMapController mapController;

  List<MapModel> mapList = [
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '700 M'),
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '3.5 K'),
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '4.7 K'),
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '6 K'),
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '7 K'),
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '8 K'),
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '10 K'),
    MapModel(name: 'Omar Taha Mohammed Alfaqeer', distance: '12 K'),
  ];

  void changeTheme() {
    if (Get.isDarkMode) {
      mapController.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MapBloc>(context),
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapListView) {
            return CupertinoScrollbar(
              thumbVisibility: true,
              thicknessWhileDragging: 8,
              thickness: 4,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(child: buildChoiceChips(context)),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MapContainerWidget(
                          mapData: mapList[index],
                          index: index,
                        );
                      },
                      childCount: mapList.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 72,
                    ),
                  ),
                ],
              ),
            );
          }
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: currentLocation, zoom: 14),
                onMapCreated: (GoogleMapController controller) {
                  googleMapControllerCompleter.complete(controller);
                  mapController = controller;
                  changeTheme();
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 90.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: buildChoiceChips(context)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildChoiceChips(
    BuildContext mapContext,
  ) =>
      Wrap(
        runSpacing: spacing,
        spacing: spacing,
        children: ChoiceChips.getMapList(
                BlocProvider.of<MapBloc>(mapContext).state is MapListView)
            .map((choiceChip) => ChoiceChip(
                  label: Text(choiceChip.label),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary),
                  onSelected: (isSelected) => setState(() {
                    ChoiceChips.getMapList(isListView).map((otherChip) {
                      if (choiceChip.label ==
                          AppLocalizations.of(Get.context!)!.list) {
                        BlocProvider.of<MapBloc>(mapContext)
                            .add(const ToListView());
                      } else if (choiceChip.label ==
                          AppLocalizations.of(Get.context!)!.map) {
                        BlocProvider.of<MapBloc>(mapContext)
                            .add(const ToMapView());
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
}
