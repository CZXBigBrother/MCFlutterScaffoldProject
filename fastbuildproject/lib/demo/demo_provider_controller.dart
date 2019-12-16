import '../index.dart';
import 'package:flutter/material.dart';

class DemoProviderController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DemoProviderControllerState();
  }
}

class DemoProviderControllerState extends State<DemoProviderController> {
  Counter counter = Counter(0);

  @override
  Widget build(BuildContext context) {
    print("build");
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (context) => counter,
      child: Scaffold(
        appBar: AppBar(
          title: Text(GmLocalizations.of(context).statemanagement),
        ),
        body: Center(
          child: Consumer(
            builder:
                (BuildContext context, Counter counterProvider, Widget child) {
              print("冲毁控件");
              return Text("data:${counterProvider.count}");
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            counter.increase();
          },
        ),
      ),
    );
  }
}

class Counter extends ChangeNotifier {
  int _count;

  Counter(this._count);

  get count => _count;

  void increase() {
    _count++;
    notifyListeners();
  }
}
