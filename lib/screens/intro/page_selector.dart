import 'package:alesea_ndef_tag/styles_and_colors.dart';
import 'package:flutter/material.dart';
import '../../globals.dart';
import 'my_tab_selector.dart';

class PageSelectorStfl extends StatefulWidget {
  const PageSelectorStfl({this.widgetPages});
  final List<Widget>? widgetPages;
  @override
  _PageSelectorStflState createState() => _PageSelectorStflState();
}

class _PageSelectorStflState extends State<PageSelectorStfl> {
  @override
  void initState() {
    super.initState();
    //main.soundManager.startEntireSequence();
  }

  @override
  void dispose() {
    //main.soundManager.stopEntireSequence();
    super.dispose();
  }

  TabController? controller;

  @override
  Widget build(BuildContext context) {
    //final Color color = Theme.of(context).accentColor;
    final Color color = Colors.red;

    controller = DefaultTabController.of(context)!;
    controller!.addListener(() {
      print("Indice TAB ${controller!.index}");
      //main.soundManager.configureVolume(controller.index);
    });

    controller!.index = (isRelease || (!skipIntroPhase)) ? 0 : 3;

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: <Widget>[
          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: IconTheme(
                  data: IconThemeData(
                    size: 228.0,
                    color: aleseaLogoColor,
                  ),
                  child:

                  TabBarView(
                      children: widget.widgetPages!.map((Widget widgetPage) {
                    return widgetPage;
                  }).toList()),
                ),
              ),
            ],
          ),
          new Align(
              alignment: Alignment.topLeft,
              //alignment: const Alignment(0.0, 0.95), //
              //child: TabPageSelector(controller: controller)
              child: Padding(padding: EdgeInsets.only(top:50,left:1),child:
              MyTabPageSelector(controller: controller!, selectedColor: aleseaPrimaryColor, color: aleseaSecondaryColor,)),
          ),
        ],
      ),
    );
  }
}
