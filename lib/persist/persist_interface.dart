abstract class Persist {
  Future<void> initPersist();

  void storeState();

  void restoreState();

  void deleteState();
}
