import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CountDownButton extends StatefulWidget {
  final VoidCallback onTap;
  const CountDownButton(
      {super.key, required this.time, required this.onTap});

  final DateTime time;

  @override
  State<CountDownButton> createState() => _CountDownButtonState();
}

class _CountDownButtonState extends State<CountDownButton>
    with TickerProviderStateMixin {
  Duration _elapsed = Duration.zero;
  // 2. declare Ticker
  late final Ticker _ticker;
  @override
  void initState() {
    super.initState();
    // 3. initialize Ticker
    _ticker = createTicker((elapsed) {
      // 4. update state
      setState(() {
        _elapsed = widget.time.difference(DateTime.now());
      });
    });
    // 5. start ticker
    _ticker.start();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours == 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    // 6. don't forget to dispose it
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: const Color.fromARGB(255, 236, 18, 18),
          foregroundColor: kWhite),
      child: _elapsed.isNegative
          ? const Text('00:00')
          : Text(' ${_printDuration(_elapsed)}'),
    );
  }
}
