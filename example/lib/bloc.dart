import 'dart:async';

import 'package:bloc_streambuilder/bloc_streambuilder.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

enum CounterPageButton { add, reset }

class Bloc {
  final _counterBehaviorSubject = BehaviorSubject<int>(seedValue: 0);
  final _counterValueSubject = ValueSubject<int>(seedValue: 0, distinct: true);
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
