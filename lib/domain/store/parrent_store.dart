//class ParentStore {
//  final stores = <Store>[];
//
//  Stream<S> nextStore<S>() => _findStore(stores, S.toString()).selfStream.map((state) => state as S);
//
//  S getStore<S>() => _findStore(stores, S.toString()) as S;
//
//  Store _findStore(List<Store> stores, String storeType) {
//    final store = stores.firstWhere((store) => store.runtimeType.toString() == storeType);
//    assert(store != null);
//    return store;
//  }
//}
