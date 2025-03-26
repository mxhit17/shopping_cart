import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalCartItemsProvider =
    StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
  int getCount() => state;
  void setItemCount(int val) => state = val;
}
