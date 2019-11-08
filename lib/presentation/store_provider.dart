import 'package:flutter/cupertino.dart';
import 'package:osam/domain/store/store.dart';
import 'package:provider/provider.dart';

class StoreProvider extends StatelessWidget {
  final Store store;
  final Widget child;
  const StoreProvider({Key key, this.store, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: store,
      child: child,
    );
  }

  static Store of(BuildContext context) => Provider.of<Store>(context);
}
