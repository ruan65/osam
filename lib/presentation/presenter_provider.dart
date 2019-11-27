import 'package:flutter/material.dart';
import 'package:osam/osam.dart';
import 'package:provider/provider.dart';

import 'presenter.dart';

class PresenterProvider<S extends Store<BaseState>, P extends Presenter> extends StatelessWidget {
  final P presenter;
  final Widget child;
  const PresenterProvider({@required Key key, @required this.presenter, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<S>(context);
    return Provider(
      create: (ctx) => presenter
        ..store = store
        ..init(),
      child: child,
      dispose: (ctx, presenter) => presenter.dispose(),
    );
  }

  static P of<P extends Presenter>(BuildContext context) => Provider.of<P>(context);
}
