import 'package:flutter/cupertino.dart';
import 'package:osam/domain/state/base_state.dart';
import 'package:osam/domain/store/store.dart';
import 'package:provider/provider.dart';

class StoreProvider<ST extends BaseState> extends StatelessWidget {
  final Store<ST> store;
  final Widget child;
  const StoreProvider({Key key, this.store, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: store,
      child: child,
    );
  }

  static Store<ST> of<ST extends BaseState>(BuildContext context) =>
      Provider.of<Store<ST>>(context);
}
