import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/custom_color.dart';

class mainDialog extends StatelessWidget {
  const mainDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _dialogHeight = _screenHeight * 0.7;

    String PLOGGING = """
1. Ready for plastic bag
2. Start running
3. Stop running and start plogging
4. Pick up trash and take a picture
5. Restart running or Stop running
6. Save the record
7. Share information or Go shop category

""";
    String encourage = """
You are a hero who save the environment
Thank you for participating !
""";

    return Dialog(
      child: Container(
        height: _dialogHeight,
        child: Column(
          children: <Widget>[
            Container(
              height: _dialogHeight * 0.3,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                  color: CustomColor.primary,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 10)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text('Plogging\nGuide',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            height: 1.5)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                      height: (_dialogHeight * 0.3) * 0.5,
                      child: Image.asset('assets/logo.png'))
                ],
              ),
            ),
            SizedBox(
              height: _dialogHeight * 0.04,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: _dialogHeight * 0.55,
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: RichText(
                            text: TextSpan(
                                text: PLOGGING,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                    color: Colors.black),
                                children: [
                              TextSpan(
                                  text: encourage,
                                  style: TextStyle(color: Colors.black54))
                            ]))),
                  ),
                  Container(),
                  Container(
                      height: _dialogHeight * 0.07,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Close'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
