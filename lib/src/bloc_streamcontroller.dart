import 'dart:async';
import 'package:bloc_streambuilder/bloc_streambuilder.dart';

class BlocStreamController<T> implements StreamController<T>, BlocStream<T> {
  final bool closeOnError;

  StreamController<T> _controller;

  BlocStream<T> get blocStream => this;

  Stream<T> get stream => _controller.stream;

  StreamSink<T> get sink => this;

  T _latestValue;
  T get value => _latestValue;
  set value(T value) => add(value);

  BlocStreamController({
    T seedValue,
    void onListen(),
    onCancel(),
    bool sync: false,
    this.closeOnError: false,
  }) {
    _controller = StreamController.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );
    _latestValue = seedValue;
  }

  @override
  void add(T event) {
    _latestValue = event;
    _controller.add(event);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    _controller.addError(error, stackTrace);
    if (closeOnError) {
      close();
    }
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
  ControllerCancelCallback get onCancel => _controller.onCancel;
  set onCancel(ControllerCancelCallback callback) =>
      _controller.onCancel = callback;

  @override
  ControllerCallback get onListen => _controller.onListen;
  set onListen(ControllerCallback callback) => _controller.onListen = callback;

  @override
  ControllerCallback onPause;

  @override
  ControllerCallback onResume;
}
