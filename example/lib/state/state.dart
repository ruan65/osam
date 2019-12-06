// ignore: must_be_immutable
import 'dart:math';

import 'package:osam/domain/state/base_state.dart';

// ignore: must_be_immutable
class AppState extends BaseState<AppState> {
  var place =
      Place(address: Address(name: 'name', description: 'somethere'), location: Point(1, 2));

  void changePlace(Place place) => this.place = place;

  @override
  List<Object> get props => [place];
}

class Place {
  final Address address;
  final Point location;

  Place({this.address, this.location});
}

class Address {
  final String name;
  final String description;

  Address({this.name, this.description});
}
