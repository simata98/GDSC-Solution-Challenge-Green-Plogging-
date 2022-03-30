import 'package:flutter/material.dart';
import 'package:gdsc_solution/model/geo_entry.dart';
import 'package:gdsc_solution/model/map_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:get/get.dart';
import '../../theme/custom_color.dart';

class SlidingBody extends StatefulWidget {
  //슬라이딩업패널을 조작하기 위한 컨트롤러
  final PanelController panelController;
  SlidingBody({Key? key, required this.panelController}) : super(key: key);

  @override
  State<SlidingBody> createState() =>
      _SlidingBodyState(panelController: panelController);
}

class _SlidingBodyState extends State<SlidingBody> {
  final PanelController panelController;
  _SlidingBodyState({required this.panelController});

  @override
  Widget build(BuildContext context) {
    LatLng _center = const LatLng(0, 0);

    return Container(
      child: Stack(
        children: [
          Container(
              child: Obx(
            () => Container(
              child: GoogleMap(
                markers: MapModel.to.markers,
                polylines: Set<Polyline>.of(MapModel.to.polyline),
                zoomControlsEnabled: false,
                onMapCreated: MapModel.to.onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 11),
                onCameraMove: (cameraPosition) {
                  MapModel.to.cameraPosition = cameraPosition;
                },
              ),
            ),
          )),
          Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 10,
              child: Material(
                //이것을 안하면 클릭할때 효과(ripple)이 네모로 나옴!! 필수!!
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
                color: CustomColor.primary,
                child: InkWell(
                  onTap: () {
                    MapModel.to.mapController!
                        .animateCamera(CameraUpdate.zoomTo(17.0));
                    MapModel.to.cameraZoom.value = 17.0;
                    MapModel.to.start.toggle();
                    MapModel.to.startRun();
                    panelController.open();
                  },
                  child: Container(
                    // 이것을 하는 이유는
                    // stack안에 stack이 들어가서 Appbar의 높이를 계산못
                    //하고 있다.
                    margin: EdgeInsets.only(bottom: Entry.to.appbarHeight),
                    width: 176,
                    height: 86,
                    child: Center(
                        child: Text(
                      "START",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
