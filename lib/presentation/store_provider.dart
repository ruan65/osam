import 'package:flutter/material.dart';
import 'package:osam/domain/store/store.dart';
import 'package:provider/provider.dart';

class StoreProvider<S extends Store> extends StatelessWidget {
  final S store;
  final Widget child;
  const StoreProvider({Key key, this.store, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: store,
      child: child,
    );
  }

  static S of<S extends Store>(BuildContext context) => Provider.of<S>(context);
}
