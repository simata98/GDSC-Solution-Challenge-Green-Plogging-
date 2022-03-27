import 'package:flutter/material.dart';
import 'package:gdsc_solution/model/map_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  PanelController newpc = PanelController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('test'),
        onPressed: () {
          panelController.close();
        },
      ),
    );
  }
}
