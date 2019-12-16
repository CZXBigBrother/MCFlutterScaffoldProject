import '../common/global.dart';
import '../i10n/localization_intl.dart';
import '../state/profile_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DemoThemeController extends StatefulWidget {
  @override
  DemoThemeControllerState createState() {
    return DemoThemeControllerState();
  }
}

class DemoThemeControllerState extends State<DemoThemeController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).theme),
      ),
      body: ListView(
        children: Global.themes.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: Container(
                color: e,
                height: 40,
              ),
            ),
            onTap: () {
              //主题更新后，MaterialApp会重新build
              Provider.of<ThemeModel>(context).theme = e;
            },
          );
        }).toList(),
      ),
    );
  }
}
