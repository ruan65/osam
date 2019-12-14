import 'package:flutter/material.dart';
import 'package:osam/osam.dart';
import 'package:provider/provider.dart';

import 'presenter.dart';


class PresenterProvider<P extends Presenter>
    extends StatelessWidget {
  final P presenter;
  final Widget child;

  const PresenterProvider(
      {@required Key key, @required this.presenter, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = InternalStoreProvider.of(context).store;
    assert(store != null);
    if (store == null)
      debugPrint(
          'insure you provided store by StoreProvider in the start of your widget tree');
    return Provider(
      key: ValueKey('PresenterProvider: %${key.toString()}'),
      create: (ctx) => presenter
        ..store = store
        ..init(),
      child: child,
      dispose: (ctx, presenter) => presenter.dispose(),
    );
  }

  static P of<P extends Presenter>(BuildContext context) =>
      Provider.of<P>(context);
}
