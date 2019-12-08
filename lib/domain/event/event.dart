import 'package:osam/osam.dart';

abstract class Event<ST extends BaseState<ST>, I extends Object> {
  ST reducer(ST state, I bundle);
  I bundle;
  Event({this.bundle});
}
