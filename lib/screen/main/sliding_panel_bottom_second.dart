import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/map_model.dart';
import '../../theme/custom_color.dart';

class SlidingPanelBottomSecond extends StatefulWidget {
  SlidingPanelBottomSecond({Key? key}) : super(key: key);

  @override
  State<SlidingPanelBottomSecond> createState() =>
      _SlidingPanelBottomSecondState();
}

class _SlidingPanelBottomSecondState extends State<SlidingPanelBottomSecond> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Material(
              clipBehavior: Clip.hardEdge,
              color: CustomColor.primary,
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(150)),
              child: InkWell(
                onTap: () {
                  MapModel.to.slidingPanelType.value = 2;
                  MapModel.to.startPlo();
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin:
                            EdgeInsets.all(MapModel.to.panelHeight.value * 0.1),
                        child: Text(
                          'YES',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MapModel.to.centerConHeight.value * 0.8,
                    height: MapModel.to.centerConHeight.value * 0.8,
                    decoration: BoxDecoration(
                        color: CustomColor.primaryAccent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: Center(
                        child: Text('Start\nPlogging',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700))),
                  )),
            ),
          ),
          Flexible(
            flex: 1,
            child: Material(
              clipBehavior: Clip.hardEdge,
              color: CustomColor.primary,
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(150)),
              child: InkWell(
                onTap: () {
                  MapModel.to.reRun();
                  MapModel.to.slidingPanelType.value = 0;
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin:
                            EdgeInsets.all(MapModel.to.panelHeight.value * 0.1),
                        child: Text(
                          'NO',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
