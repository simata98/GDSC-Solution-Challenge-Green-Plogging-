import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdsc_solution/screen/main/main_finish_posting.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

import '../../model/map_model.dart';
import '../../model/upload_images.dart';
import '../../theme/custom_color.dart';

class SlidingPanelBottomForth extends StatefulWidget {
  SlidingPanelBottomForth({Key? key}) : super(key: key);

  @override
  State<SlidingPanelBottomForth> createState() =>
      _SlidingPanelBottomForthState();
}

class _SlidingPanelBottomForthState extends State<SlidingPanelBottomForth> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(3.0, 3.0),
                            blurRadius: 6,
                            spreadRadius: 1)
                      ]),
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    color: CustomColor.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: InkWell(
<<<<<<< Updated upstream
                      onTap: () async {
                        MapModel.to.finishState.toggle();
                        //await MapModel.to.uploadRecord();
                        MapModel.to.uploadRecord();

                        //초기화
=======
                      onTap: () {
                        MapModel.to.locationSubscription?.resume();
                        MapModel.to.update();
>>>>>>> Stashed changes
                        MapModel.to.slidingPanelMinH.value = 0.0;
                        MapModel.to.resetRun();
                        MapModel.to.slidingPanelType.value = 0;
                      },
                      child: Container(
                        width: double.infinity,
                        height: MapModel.to.panelHeight.value * 0.2,
                        child: Center(
                          child: Text(
                            'Finish',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: MapModel.to.panelWidth.value * 0.075,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
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
            flex: 5,
            child: Container(
              child: Center(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0),
                          blurRadius: 6,
                          spreadRadius: 1),
                    ]),
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () {
                      Get.to(MainFinishPosting());
                    },
                    child: Container(
                        width: MapModel.to.panelWidth.value * 0.11,
                        height: MapModel.to.panelWidth.value * 0.11,
                        child: Icon(
                          Icons.share,
                          color: CustomColor.primary,
                        )),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
