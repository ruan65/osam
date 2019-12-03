import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';

void main() {
  test('fits', () {
    final map = <String, Map<String, int>> {};
    print(ComparableWrapper(map).hashCode);
    map['123'] = <String, int>{'1' : null};
    print(ComparableWrapper(map).hashCode);
    map.clear();
    print(ComparableWrapper(map).hashCode);
  });
}

// Uses to compare two objects and calculate "good" hash
class ComparableWrapper extends Equatable {
  final Object property;

  ComparableWrapper(this.property);

  @override
  List<Object> get props => [property];
}
