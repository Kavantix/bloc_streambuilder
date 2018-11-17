import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

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
