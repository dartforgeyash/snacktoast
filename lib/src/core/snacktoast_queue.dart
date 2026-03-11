import 'dart:async';

/// Manages the sequential display of notifications.
/// Prevents visual stacking and enforces max queue limit.
///
/// Design: Simple FIFO queue with async coordination.
/// Manages the sequential display of notifications.
class SnackToastQueue {
  /// Creates a [SnackToastQueue] with a [maxSize].
  SnackToastQueue({required int maxSize}) : _maxSize = maxSize;

  final int _maxSize;
  final List<_QueueEntry> _queue = [];
  bool _isProcessing = false;

  /// Total entries currently pending or active.
  int get length => _queue.length;

  /// Whether the queue has reached its maximum size.
  bool get isFull => _queue.length >= _maxSize;

  /// Adds a task to the queue.
  /// [task] must complete (resolve its completer) when the notification is dismissed.
  /// Silently drops entries when queue is full to prevent unbounded growth.
  void enqueue(Future<void> Function() task) {
    if (isFull) {
      return; // Drop silently — caller is notified via design contract
    }
    final entry = _QueueEntry(task);
    _queue.add(entry);
    _process();
  }

  void _process() {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;
    _runNext();
  }

  Future<void> _runNext() async {
    if (_queue.isEmpty) {
      _isProcessing = false;
      return;
    }
    final entry = _queue.first;
    try {
      await entry.task();
    } catch (_) {
      // Swallow individual task errors
    } finally {
      if (_queue.isNotEmpty) {
        _queue.removeAt(0);
      }
      _runNext();
    }
  }

  /// Clears all pending entries. Does NOT cancel the active entry.
  /// Clears all pending entries from the queue.
  void clear() => _queue.clear();
}

class _QueueEntry {
  const _QueueEntry(this.task);
  final Future<void> Function() task;
}
