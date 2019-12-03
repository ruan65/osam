import 'package:flutter/material.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:provider/provider.dart';

import 'life_cycle_wrapper.dart';


class StoreProvider<S extends Store<BaseState>> extends StatelessWidget {
  final S store;
  final Widget child;
  const StoreProvider({@required Key key, @required this.store, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      key: ValueKey('StoreValue: ${key.toString()}'),
      value: store,
      child: LifecycleWrapper<S>(child: child, key: ValueKey('LifecycleWrapper: ${key.toString()}')),
    );
  }

  static S of<S extends Store<BaseState>>(BuildContext context) => Provider.of<S>(context);
}


