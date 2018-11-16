import 'dart:async';

import 'package:bloc_streambuilder/bloc_stream.dart';
import 'package:flutter/widgets.dart';

export 'package:bloc_streambuilder/bloc_streamcontroller.dart';
export 'package:bloc_streambuilder/bloc_stream.dart';
export 'package:bloc_streambuilder/bloc_sink.dart';

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
    return StreamBuilder(
      initialData: stream.value,
      stream: stream,
      builder: builder,
    );
  }
}
