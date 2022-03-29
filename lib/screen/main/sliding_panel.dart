import 'package:flutter/material.dart';
import 'package:gdsc_solution/model/map_model.dart';
import 'package:gdsc_solution/screen/main/sliding_panel_bottom_forth.dart';
import 'package:gdsc_solution/screen/main/sliding_panel_bottom_second.dart';
import 'package:gdsc_solution/screen/main/sliding_panel_bottom_first.dart';
import 'package:gdsc_solution/screen/main/sliding_panel_bottom_third.dart';
import 'package:gdsc_solution/screen/main/sliding_panel_box.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../model/map_model.dart';
import '../../theme/custom_color.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;
  PanelWidget(
      {Key? key, required this.scrollController, required this.panelController})
      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState(
      scrollController: scrollController, panelController: panelController);
}

class _PanelWidgetState extends State<PanelWidget> {
  final ScrollController scrollController;
  final PanelController panelController;
  _PanelWidgetState(
      {required this.scrollController, required this.panelController});

  final int flexVal = 55;

  double ratio(int flexVal) {
    return flexVal / 100;
  }

  final int spacerVal = 1;

  @override
  Widget build(BuildContext context) {
    //가운데 컨테이너 여기서 조절
    double centerConHeight =
        (MapModel.to.panelHeight.value * (flexVal.toDouble() / 100)) * 0.85;
    double centerConWidth = MapModel.to.panelWidth.value * 0.85;

    //각각의 박스 크기 여기서 조절
    double boxHeight = centerConHeight * 0.42;
    double boxWidth = centerConWidth * 0.45;

    MapModel.to.centerConHeight.value = centerConHeight;
    MapModel.to.centerConWidth.value = centerConWidth;
    MapModel.to.panelController = panelController;

    Widget bottomSetting() {
      switch (MapModel.to.slidingPanelType.value) {
        case 0:
          return SlidingPanelBottomFirst();
        case 1:
          return SlidingPanelBottomSecond();
        case 2:
          return SlidingPanelBottomThird();
        case 3:
          return SlidingPanelBottomForth();
        default:
      }

      return SlidingPanelBottomFirst();
    }

    return Container(
      color: CustomColor.primaryPastel,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: flexVal,
            child: Container(
              child: Center(
                child: Container(
                  height: centerConHeight,
                  width: centerConWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SlidingPanelBox(
                            type: 'Distance',
                          ),
                          Spacer(),
                          SlidingPanelBox(
                            type: 'Time',
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SlidingPanelBox(
                            type: 'Plogging',
                          ),
                          Spacer(),
                          SlidingPanelBox(
                            type: 'Speed',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(flex: 100 - flexVal, child: Obx(() => bottomSetting())),
        ],
      ),
    );
  }
}
