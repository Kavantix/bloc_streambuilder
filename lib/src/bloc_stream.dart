import 'dart:async';

abstract class BlocStream<T> {
  Stream<T> get stream;
  T get value;
}
