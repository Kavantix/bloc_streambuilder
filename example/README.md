# A simple example

This example show how you can make the simple counter app with the library.
It also shows a comparison to what it intends to fix.

It uses the BLOC pattern.

### The build method of the page
In this build method we see that using an inherited widget the bloc is retrieved.
It is then used for displaying the counter and handling the buttons
``` dart
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
		...

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

    	...
      floatingActionButton: new FloatingActionButton(
        onPressed: () => bloc.buttonPress.add(CounterPageButton.add),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
```

### The bloc
This bloc has a single stream (ValueObservable) and a single sink.
The sink is simply using the built in dart StreamController.
But the stream uses the new ValueSubject class which handles keeping track of the value.
``` dart
class Bloc {
  final _counterValueSubject = ValueSubject<int>(seedValue: 0, distinct: true);
  ValueObservable<int> get counterValue => _counterValueSubject;

  final _buttonPressController = StreamController<CounterPageButton>();
  Sink<CounterPageButton> get buttonPress => _buttonPressController;

  Bloc() {
    _buttonPressController.stream.listen(_pressedButton);
  }

  void _pressedButton(CounterPageButton button) {
    switch (button) {
      case CounterPageButton.add:
        _counterValueSubject.value += 1;
        break;
      case CounterPageButton.reset:
        _counterValueSubject.value = 0;
        break;
    }
  }
}
```