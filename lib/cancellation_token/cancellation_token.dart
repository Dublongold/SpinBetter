class CancellationToken {
  bool _isCancelled = false;

  bool isCancelled() {
    return _isCancelled;
  }

  void cancel() {
    _isCancelled = true;
  }
}