import 'package:osam/osam.dart';

abstract class Reducer<ST extends BaseState<ST>, I extends Object> {
  ST reducer(ST state, I bundle);
}

class Event {}

abstract class ModificationEvent<ST extends BaseState<ST>, I extends Object> extends Event
    implements Reducer<ST, I> {
  I bundle;

  ModificationEvent({this.bundle});
}

abstract class SideEffectEvent<I extends Object> extends Event {
  I bundle;
  SideEffectEvent({this.bundle});
}
