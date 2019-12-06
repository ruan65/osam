import 'dart:async';

import 'package:example/state/state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/osam.dart';
import 'package:osam/presentation/presenter.dart';

class ExamplePresenter extends Presenter<Store<AppState>> {
  StreamSubscription<Place> propertySub;
  StreamController<Place> modelBroadcaster;

  @override
  void init() {
    modelBroadcaster = StreamController<Place>();
  }

  void increment(Place place) =>
      store.dispatchEvent(event: Event.modify(reducer: (state, _) => state..changePlace(place)));

  Place get initialData => store.state.place;

  Stream<Place> get stream => store.state.propertyStream<Place>((state) => state.place);

  @override
  void dispose() {
    propertySub?.cancel();
    modelBroadcaster?.close();
  }
}
