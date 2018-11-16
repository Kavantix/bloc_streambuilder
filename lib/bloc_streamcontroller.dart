import 'dart:async';

import 'package:bloc_streambuilder/bloc_sink.dart';
import 'package:bloc_streambuilder/bloc_stream.dart';

class BlocStreamController<T> implements StreamController<T> {
  StreamController<T> _controller;

  BlocStream<T> _stream;
  BlocStream<T> get stream => _stream;

  BlocSink<T> _sink;
  BlocSink<T> get sink => _sink;

  T _latestValue;
  T get value => _latestValue;
  set value(T value) => add(value);

  BlocStreamController({
    T seedValue,
    void onListen(),
    onCancel(),
    bool sync: false,
  }) {
    _controller = StreamController.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );
    _stream = BlocStream(() => _controller.stream, () => value);
    _sink = BlocSink(() => this);
    _latestValue = seedValue;
  }

  @override
  void add(T event) {
    _latestValue = event;
    _controller.add(event);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    _latestValue = null;
    _controller.addError(error, stackTrace);
  }

  @override
  Future close() {
    return _controller.close();
  }

  Future get done => _controller.done;

  @override
  Future addStream(Stream<T> source, {bool cancelOnError}) {
    return _controller.addStream(source, cancelOnError: cancelOnError);
  }

  @override
  bool get hasListener => _controller.hasListener;

  @override
  bool get isClosed => _controller.isClosed;

  @override
  bool get isPaused => _controller.isPaused;

  @override
  ControllerCancelCallback onCancel;

  @override
  ControllerCallback onListen;

  @override
  ControllerCallback onPause;

  @override
  ControllerCallback onResume;
}
