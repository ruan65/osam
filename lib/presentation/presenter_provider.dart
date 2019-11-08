import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presenter.dart';

class PresenterProvider<PT extends Presenter> extends StatelessWidget {
  final Widget child;
  final PT presenter;
  const PresenterProvider({Key key, this.child, this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (ctx) => this,
      child: child,
      dispose: (ctx, PresenterProvider presenterProvider) => presenterProvider.dispose(),
    );
  }

  static Presenter of<PT extends Presenter>(BuildContext context) => Provider.of<PT>(context);

  void dispose() => presenter.dispose();
}
