import 'dart:async';

class BlocSink<T> extends StreamSink<T> {
  final StreamSink<T> Function() _getSink;

  BlocSink(this._getSink);

  StreamSink<T> get sink => _getSink();
  setValue(T value) => sink.add(value);

  @override
  void add(T event) => sink.add(event);
  @override
  void addError(Object error, [StackTrace stackTrace]) =>
      sink.addError(error, stackTrace);
  @override
  Future<dynamic> close() => sink.close();

  @override
  Future addStream(Stream<T> stream) {
    return sink.addStream(stream);
  }

  // TODO: implement done
  @override
  Future get done => null;
}
