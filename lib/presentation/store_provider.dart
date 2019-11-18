import 'package:flutter/material.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:provider/provider.dart';

class StoreProvider<S extends Store<BaseState>> extends StatelessWidget {
  final S store;
  final Widget child;
  const StoreProvider({@required Key key, @required this.store, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: store,
      child: child,
    );
  }

  static S of<S extends Store<BaseState>>(BuildContext context) => Provider.of<S>(context);
}
