// ignore: must_be_immutable
import 'package:flutter/widgets.dart';
import 'package:osam/domain/store/store.dart';
import 'package:osam/osam.dart';

class LifecycleWrapper<S extends Store<BaseState>> extends StatefulWidget {
  final Widget child;

  const LifecycleWrapper({Key key, this.child}) : super(key: key);
  @override
  _LifecycleWrapperState createState() => _LifecycleWrapperState<S>();
}

class _LifecycleWrapperState<S extends Store<BaseState>> extends State<LifecycleWrapper>
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
    InternalStoreProvider.of(context).store.storeState();
  }
}
