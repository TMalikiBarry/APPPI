import 'package:flutter/material.dart';

import '../../core/theme.dart';

class NumberIncWidget extends StatelessWidget {
  ///
  const NumberIncWidget({
    super.key,
    required this.number,
    required this.onChange,
    this.min,
    this.max
  });

  final int number;
  final ValueChanged<int> onChange;
  final int? min;
  final int? max;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton -
        FloatingActionButton.small(
          backgroundColor:
              (number > (min??2)) 
              ? Theme.of(context).colorScheme.primary 
              : Themer.gray,
          onPressed: (number > (min??2))
              ? () {
                  int newValue = number - 1;
                  onChange(newValue);
                }
              : null,
          elevation: 0,
          heroTag: "_decrement",
          child: const Icon(Icons.remove, size: 18),
        ),
        // Valeur actuelle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            number.toString(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        // Bouton +
        FloatingActionButton.small(
          backgroundColor:
              (max == null || number < max!) 
              ? Theme.of(context).colorScheme.primary 
              : Themer.gray,
          onPressed: (max == null || number < max!) 
          ? () {
            int newValue = number + 1;
            onChange(newValue);
          }: null,
          elevation: 0,
          heroTag: "_increment",
          child: const Icon(Icons.add, size: 18),
        ),
      ],
    );
  }
}
