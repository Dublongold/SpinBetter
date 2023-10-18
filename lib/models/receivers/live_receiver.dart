import '../entities/live_entry.dart';

class LiveReceiver {
  const LiveReceiver({
    required this.count,
    required this.items
  });
  final int count;
  final List<LiveEntry> items;
}