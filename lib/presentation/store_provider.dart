import 'package:flutter/material.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';

import 'life_cycle_wrapper.dart';

class StoreProvider<S extends Store<BaseState>> extends StatelessWidget {
  final S store;
  final Widget child;

  const StoreProvider({Key key = const ValueKey('_store'), @required this.store, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InternalStoreProvider(
        key: ValueKey('internal_store_provider'),
        store: store,
        child: store.isPersistEnabled
            ? LifecycleWrapper<S>(child: child, key: ValueKey('LifecycleWrapper: ${key.toString()}'))
            : child);
  }
}

class InternalStoreProvider extends InheritedWidget {
  const InternalStoreProvider({
    @required Key key,
    @required this.child,
    @required this.store,
  }) : super(key: key, child: child);

  final Store store;
  final Widget child;

  static InternalStoreProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: InternalStoreProvider);

  @override
  bool updateShouldNotify(InternalStoreProvider oldWidget) => this.store != oldWidget.store;
}
