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

// ignore: must_be_immutable
class _LifecycleWrapper<S extends Store<BaseState>> extends StatefulWidget {
  Widget child;
  @override
  _LifecycleWrapperState createState() => _LifecycleWrapperState<S>();
}

class _LifecycleWrapperState<S extends Store<BaseState>> extends State<_LifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    StoreProvider.of<S>(context).storeState();
  }
}
