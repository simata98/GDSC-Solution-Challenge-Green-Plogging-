import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../model/map_model.dart';
import '../../theme/custom_color.dart';

class SlidingPanelBox extends StatefulWidget {
  final String type;
  SlidingPanelBox({Key? key, required this.type}) : super(key: key);

  @override
  State<SlidingPanelBox> createState() => _SlidingPanelBoxState(type: type);
}

class _SlidingPanelBoxState extends State<SlidingPanelBox> {
  final String type;
  _SlidingPanelBoxState({required this.type});
  @override
  Widget build(BuildContext context) {
    final int flexVal = 55;

    //가운데 컨테이너 여기서 조절
    double centerConHeight =
        (MapModel.to.panelHeight.value * (flexVal.toDouble() / 100)) * 0.85;
    double centerConWidth = MapModel.to.panelWidth.value * 0.85;

    //각각의 박스 크기 여기서 조절
    double boxHeight = centerConHeight * 0.42;
    double boxWidth = centerConWidth * 0.45;

    IconData? icon;
    String? unit;

    switch (type) {
      case 'Distance':
        icon = Icons.route_outlined;
        unit = "km";
        break;
      case 'Time':
        icon = Icons.timer_outlined;
        unit = "";
        break;
      case 'Plogging':
        icon = Icons.recycling_rounded;
        unit = "times";
        break;
      case 'Speed':
        icon = Icons.directions_run;
        unit = "KM/H";
        break;
    }

    String widgetPerunit() {
      switch (type) {
        case 'Distance':
          return '${(MapModel.to.dist / 1000).toStringAsFixed(2)}';
        case 'Time':
          if (StopWatchTimer.getRawMinute(MapModel.to.time.value) >= 60) {
            return '${StopWatchTimer.getDisplayTimeHours(MapModel.to.time.value)}' +
                ':' +
                '${StopWatchTimer.getDisplayTimeMinute(MapModel.to.time.value)}' +
                ':' +
                '${StopWatchTimer.getDisplayTimeSecond(MapModel.to.time.value)}';
          } else {
            return '${StopWatchTimer.getRawMinute(MapModel.to.time.value)}' +
                ':' +
                '${StopWatchTimer.getDisplayTimeSecond(MapModel.to.time.value)}';
          }

        case 'Plogging':
          return '${MapModel.to.plogging}';
        case 'Speed':
          return '${MapModel.to.speed.toStringAsFixed(2)}';
      }
      return '${(MapModel.to.dist / 1000).toStringAsFixed(2)}';
    }

    return Container(
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            border: Border.all(width: 2, color: CustomColor.primary)),
        child: Center(
          child: Container(
            width: boxWidth * 0.8,
            height: boxHeight * 0.77,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(
                  flex: 2,
                ),
                Container(
                  child: Icon(
                    icon,
                    size: boxHeight * 0.6,
                    color: CustomColor.primary,
                  ),
                ),
                Spacer(
                  flex: 5,
                ),
                Container(
                  child: Container(
                    width: boxWidth * 0.47,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Container(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: widgetPerunit(),
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 60,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900)),
                                      TextSpan(
                                          text: ' $unit',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900))
                                    ]),
                                  ),
                                )),
                            Text('$type',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500))
                          ]),
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
