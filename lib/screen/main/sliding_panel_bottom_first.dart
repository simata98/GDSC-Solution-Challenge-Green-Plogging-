import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../model/map_model.dart';
import '../../theme/custom_color.dart';

class SlidingPanelBottomFirst extends StatelessWidget {
  const SlidingPanelBottomFirst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              child: Center(
                child: Material(
                  color: CustomColor.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: MapModel.to.panelHeight.value * 0.35,
                      height: MapModel.to.panelHeight.value * 0.35,
                      child: Icon(
                        Icons.pause_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              child: Center(
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: CustomColor.primaryBold,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () {
                      if (!Get.isSnackbarOpen) {
                        Get.snackbar('러닝중지', '정지버튼을 길게 누르면 종료됩니다.',
                            margin: EdgeInsets.only(top: 20),
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                            backgroundColor: CustomColor.primary,
                            duration: const Duration(seconds: 2),
                            colorText: Colors.white,
                            icon: Icon(
                              Icons.touch_app,
                              color: Colors.white,
                              size: 30,
                            ),
                            snackPosition: SnackPosition.TOP);
                      }
                    },
                    onLongPress: () {
                      MapModel.to.stopRun();
                    },
                    child: Container(
                      width: MapModel.to.panelHeight.value * 0.35,
                      height: MapModel.to.panelHeight.value * 0.35,
                      child: Icon(
                        Icons.stop,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
