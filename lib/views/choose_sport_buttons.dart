import 'package:flutter/material.dart';
import 'package:spin_better/res/colors.dart';

import '../../res/strings.dart';

class ChooseSportButtons extends StatefulWidget {
  const ChooseSportButtons({
    super.key,
    required this.onPressCallback,
    this.enabled = true
  });

  final Future<void> Function(int) onPressCallback;
  final bool enabled;

  @override
  State<ChooseSportButtons> createState() => _ChooseSportButtonsState();
}

class _ChooseSportButtonsState extends State<ChooseSportButtons> {
  int selectedSport = 1;
  bool enabled = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: inactive,
        borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _createButton(1),
          _createButtonSeparator(selectedSport > 2),
          _createButton(2),
          _createButtonSeparator(selectedSport == 1 || selectedSport == 4),
          _createButton(3),
          _createButtonSeparator(selectedSport < 3),
          _createButton(4),
        ],
      ),
    );
  }

  Widget _createButtonSeparator(bool condition) {
    return Container(
        width: 1,
        height: 25,
        decoration: BoxDecoration(
            color: condition ? Colors.white : Colors.transparent
        ),
      );
  }

  Expanded _createButton(int buttonId) {
    void Function()? onPressed = (enabled
        && selectedSport != buttonId
          && widget.enabled) ? () => _selectSport(buttonId) : null;

    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty
              .all(selectedSport == buttonId ? active : inactive),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(8)
            )
          ))
        ),
        onPressed: onPressed,
        child: Text(_getButtonText(buttonId),
          style: const TextStyle(color: Colors.white),)
      ),
    );
  }

  String _getButtonText(int buttonId) => switch(buttonId) {
    1 => football,
    2 => hockey,
    3 => basketball,
    4 => tennis,
    _ => throw ArgumentError()
  };

  void _selectSport(int sportId) {
    setState(() {
      selectedSport = sportId;
      enabled = false;
    });
    widget.onPressCallback(sportId).then((_) => enabled = true);
  }
}