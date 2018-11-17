import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

///
/// A special StreamBuilder that takes an ValueObservable as stream
///
/// It makes sure that the first time the `builder` is called it will have data
/// and get an active ConnectionState
///
/// ###Example
///
///     ValueObservable<int> stream = ValueSubject(seedValue: 0);
///
///     ValueObservableBuilder(
///       builder: (context, snapshot) { // Only called once and immediately with data if the stream has data
///
///         print(
///             "Build called with data: ${snapshot.data}, connectionState: ${snapshot.connectionState}"
///         ); // First time it prints "Build called with data: 0, connectionState: ConnectionState.active"
///
///         return new Text('${snapshot.data}');
///       },
///       stream: stream,
///     )
///
///
class ValueObservableBuilder<T> extends StatelessWidget {
  final ValueObservable<T> stream;
  final AsyncWidgetBuilder<T> builder;

  const ValueObservableBuilder({
    Key key,
    @required this.builder,
    @required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: stream.value,
      stream: stream,
      builder: (context, snapshot) {
        assert(builder != null && stream != null);
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData) {
          return builder(
            context,
            AsyncSnapshot<T>.withData(ConnectionState.active, snapshot.data),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
