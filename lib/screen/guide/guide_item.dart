import 'package:flutter/material.dart';

class GuideItem extends StatefulWidget {
  GuideItem({Key? key, this.num, this.image, this.text, this.textBig})
      : super(key: key);
  int? num;
  String? image;
  String? text;
  String? textBig;

  @override
  State<GuideItem> createState() => _GuideItemState();
}

class _GuideItemState extends State<GuideItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.num == 0) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Image.asset('${widget.image}', width: 300, height: 300),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: 80,
              color: Color.fromARGB(255, 0, 105, 49),
              child: Center(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '${widget.textBig}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35)),
                    TextSpan(
                        text: '${widget.text}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20))
                  ]),
                ),
              ))
        ],
      );
    } else if (widget.num == 1) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Image.asset('${widget.image}', width: 300, height: 300),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              height: 80,
              color: Color.fromARGB(255, 0, 105, 49),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.text}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Text('${widget.textBig}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35))
                ],
              )))
        ],
      );
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Image.asset('${widget.image}', width: 300, height: 300),
        ),
        Container(
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: Color.fromARGB(255, 0, 105, 49),
            child: Center(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '${widget.text}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  TextSpan(
                      text: '${widget.textBig}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35)),
                ]),
              ),
            ))
      ],
    );
  }
}
