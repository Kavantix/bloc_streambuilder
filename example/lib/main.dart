import 'dart:async';

import 'package:bloc_streambuilder/bloc_streambuilder.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

enum CounterPageButton { add, reset }

class Bloc {
  final _counterBehaviorSubject = BehaviorSubject<int>(seedValue: 0);
  final _counterValueSubject = ValueSubject<int>(seedValue: 0);
  ValueObservable<int> get counterBehavior => _counterBehaviorSubject;
  ValueObservable<int> get counterValue => _counterValueSubject;

  final _buttonPressController = StreamController<CounterPageButton>();
  Sink<CounterPageButton> get buttonPress => _buttonPressController;

  Bloc() {
    _buttonPressController.stream.listen(_pressedButton);
  }

  void _pressedButton(CounterPageButton button) {
    switch (button) {
      case CounterPageButton.add:
        _counterBehaviorSubject.value += 1;
        _counterValueSubject.value += 1;
        break;
      case CounterPageButton.reset:
        _counterBehaviorSubject.value = 0;
        _counterValueSubject.value = 0;
        break;
    }
  }

  void dispose() {
    _buttonPressController.close();
    _counterBehaviorSubject.close();
    _counterValueSubject.close();
  }
}

class BlocProvider extends InheritedWidget {
  final Bloc bloc;

  const BlocProvider({this.bloc, Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

  static Bloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider)
        ?.bloc;
  }
}

class MyAppState extends State<MyApp> {
  Bloc _bloc;

  @override
  void initState() {
    _bloc = Bloc();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(
          title: 'Counter Example',
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        leading: IconButton(
          icon: Icon(Icons.restore_page),
          onPressed: () => bloc.buttonPress.add(CounterPageButton.reset),
        ),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            ValueObservableBuilder(
              builder: (context, snapshot) {
                print(
                    "Value build called with data: ${snapshot.data}, connectionState: ${snapshot.connectionState}");
                return new Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
              stream: bloc.counterValue,
            ),
            SizedBox(height: 20.0),
            StreamBuilder(
              initialData: bloc.counterBehavior.value,
              builder: (context, snapshot) {
                print(
                    "Behavior build called with data: ${snapshot.data}, connectionState: ${snapshot.connectionState}");
                return new Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
              stream: bloc.counterBehavior,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => bloc.buttonPress.add(CounterPageButton.add),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
