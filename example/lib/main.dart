import 'package:bloc_streambuilder/bloc_streambuilder.dart';
import './bloc.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
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
      ),
    );
  }
}
