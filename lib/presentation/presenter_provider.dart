import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:osam/osam.dart';
import 'package:provider/provider.dart';

import 'presenter.dart';

class PresenterProvider<S extends Store> extends StatelessWidget {
  final Presenter presenter;
  final Widget child;
  const PresenterProvider({Key key, this.presenter, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (ctx) => presenter
        ..store = StoreProvider.of<S>(context)
        ..init(),
      child: child,
      dispose: (ctx, presenter) => presenter.dispose(),
    );
  }

  static PT of<PT extends Presenter>(BuildContext context) => Provider.of<PT>(context);
}

@experimental
class MultiPresenterProvider extends StatelessWidget {
  final List<Presenter> presenters;
  final Widget child;
  const MultiPresenterProvider({Key key, this.presenters, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: presenters
            .map((presenter) => Provider(
                  builder: (ctx) => presenter
                    ..store = StoreProvider.of(context)
                    ..init(),
                  child: child,
                  dispose: (ctx, Presenter presenter) => presenter.dispose(),
                ))
            .toList());
  }

  static PT of<PT extends Presenter>(BuildContext context) => Provider.of<PT>(context);
}
