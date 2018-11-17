import 'package:bloc_streambuilder/bloc_streambuilder.dart';
import 'package:flutter/widgets.dart';

class BlocStreamBuilder<T> extends StatelessWidget {
  final BlocStream<T> stream;
  final AsyncWidgetBuilder<T> builder;

  const BlocStreamBuilder({
    Key key,
    @required this.builder,
    @required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: stream.value,
      stream: stream.stream,
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
