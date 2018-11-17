import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// A special StreamController that captures the latest item that has been
/// added to the controller, but unlike BehaviorSubject does not emit that as the first item.
///
/// This subject allows sending data, error and done events to the listener.
/// Any new events will be
/// appropriately sent to the listeners. It is possible to provide a seed value
/// that will be emitted if no items have been added to the subject.
///
/// ValueSubject is, by default, a broadcast (aka hot) controller, in order
/// to fulfill the Rx Subject contract. This means the Subject's `stream` can
/// be listened to multiple times.
///
/// ### Example
///
///     final subject = new ValueSubject<int>();
///
///     subject.add(1);
///     subject.add(2);
///
///     subject.stream.listen(print); // prints nothing
///
///     subject.add(3); // prints 3;
///
///     print(subject.value); // prints 3;
///
///     subject.stream.listen(print); // prints nothing
///
/// ### Example with seed value
///
///     final subject = new ValueSubject<int>(seedValue: 1);
///
///     subject.stream.listen(print); // prints nothing
///     print(subject.value); // prints 3;
///     print(subject.value); // prints 3;
class ValueSubject<T> extends Subject<T> implements ValueObservable<T> {
  T _latestValue;

  ValueSubject._(
    StreamController<T> controller,
    Observable<T> observable,
    this._latestValue,
  ) : super(controller, observable);

  factory ValueSubject({
    T seedValue,
    void onListen(),
    void onCancel(),
    bool sync: false,
    bool distinct: false,
    bool equals(T previous, T next),
  }) {
    // ignore: close_sinks
    final controller = new StreamController<T>.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );

    final observable = distinct
        ? new Observable(controller.stream.distinct(equals))
        : new Observable(controller.stream);

    return new ValueSubject<T>._(
      controller,
      observable,
      seedValue,
    );
  }

  @override
  void onAdd(T event) {
    _latestValue = event;
  }

  @override
  ValueObservable<T> get stream => this;

  /// Get the latest value emitted by the Subject
  @override
  T get value => _latestValue;

  /// Set and emit the new value
  set value(T newValue) => add(newValue);
}
