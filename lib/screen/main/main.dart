import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdsc_solution/components/mainMapDrawer.dart';
import 'package:gdsc_solution/screen/main/main_dialog.dart';
import 'package:gdsc_solution/screen/main/sliding_body.dart';
import 'package:gdsc_solution/screen/main/sliding_panel.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsc_solution/model/geo_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/map_model.dart';

class mapMain extends StatefulWidget {
  mapMain({Key? key}) : super(key: key);

  @override
  State<mapMain> createState() => _mapMainState();
}

class _mapMainState extends State<mapMain> {
  _mapMainState();

  //슬라이드 패널 컨트롤러
  final panelController = PanelController();

  double _fabHeight = 15.0;
  double _fabHeightClosed = 15.0;

  _loadCounter() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    int _counter = (_prefs.getInt('counter') ?? 0);
    if (_counter == 0) {
      _prefs.setInt('counter', 1);
      Get.dialog(new mainDialog());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  @override
  Widget build(BuildContext context) {
    //Check IOS Platform
    final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHeight = MediaQuery.of(context).size.height;

    //앱바 높이
    final double _appBarHeight = _screenHeight * 0.065;

    final getController = Get.put(Entry());
    getController.appbarHeight = _appBarHeight;

    MapModel.to.panelHeight.value = _screenHeight * 0.4;
    MapModel.to.panelWidth.value = _screenWidth;

    return Scaffold(
        drawer: Container(
            width: _screenWidth * 0.7,
            child: Drawer(child: new mainMapDrawer())),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(_appBarHeight),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Image.asset('assets/logo.png', width: _appBarHeight),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => {Get.dialog(new mainDialog())},
                icon: const Icon(Icons.help),
                color: CustomColor.primary,
              )
            ],
          ),
        ),
        body: Stack(children: [
          Obx(
            () => SlidingUpPanel(
              isDraggable: MapModel.to.slidingDraggable.value,
              maxHeight: _screenHeight * 0.4,
              minHeight: MapModel.to.slidingPanelMinH.value,
              controller: panelController,
              parallaxEnabled: true,
              parallaxOffset: .6,
              panelBuilder: (controller) => PanelWidget(
                scrollController: controller,
                panelController: panelController,
              ),
              body: SlidingBody(
                panelController: panelController,
              ),
              onPanelSlide: (position) => setState(() {
                double tmp = MapModel.to.panelHeight.value -
                    MapModel.to.slidingPanelMinH.value;
                _fabHeight =
                    position * tmp + MapModel.to.slidingPanelMinH.value;
              }),
            ),
          ),
          Positioned(
            left: 15,
            bottom: _fabHeight + _fabHeightClosed,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 4),
                              spreadRadius: 1.0,
                              blurRadius: 5.0,
                              color: Colors.grey),
                        ]),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: CustomColor.primary,
                      child: InkWell(
                        onTap: () {
                          MapModel.to.mapController?.animateCamera(
                              CameraUpdate.zoomTo(
                                  ++MapModel.to.cameraZoom.value));
                        },
                        child: Container(
                          width: _screenWidth * 0.13,
                          height: _screenHeight * 0.06,
                          child: Icon(
                            Icons.add,
                            size: _screenWidth * 0.08,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _screenHeight * 0.01,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(3, 4),
                              spreadRadius: 1.0,
                              blurRadius: 5.0,
                              color: Colors.grey),
                        ]),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: CustomColor.primary,
                      child: InkWell(
                        onTap: () {
                          MapModel.to.mapController?.animateCamera(
                              CameraUpdate.zoomTo(
                                  --MapModel.to.cameraZoom.value));
                        },
                        child: Container(
                          width: _screenWidth * 0.13,
                          height: _screenHeight * 0.06,
                          child: Icon(
                            Icons.remove,
                            size: _screenWidth * 0.08,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            //여기를 수정해야함
            () => Positioned(
              bottom: _fabHeight,
              //지금 여기 때문에 무한 루프돌고있음
              child: MapModel.to.slidingPanelMinH != 0.0
                  ? Image.file(
                      MapModel.to.viewImage!,
                      width: _screenWidth,
                      height: _screenHeight * 0.25,
                      fit: BoxFit.fitWidth,
                    )
                  : Container(),
            ),
          )
        ]));
  }
}
