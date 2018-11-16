import 'dart:async';

class BlocStream<T> extends Stream<T> {
  final Stream<T> Function() _getStream;
  final T Function() _getValue;

  BlocStream(this._getStream, this._getValue);

  Stream<T> get stream => _getStream();
  T get value => _getValue();

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return stream.listen(onData,
        cancelOnError: cancelOnError, onDone: onDone, onError: onError);
  }
}
