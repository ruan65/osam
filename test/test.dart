import 'package:flutter_test/flutter_test.dart';
import 'package:osam/util/comparable_wrapper.dart';

void main() {
  test('fits', () {
    final map = {1: '1', 2: '2'};
    print(ComparableWrapper(map).hashCode);
    map.remove(1);
    print(ComparableWrapper(map).hashCode);
  });
}
