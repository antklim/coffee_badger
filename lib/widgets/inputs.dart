import 'package:flutter/material.dart';

Widget _buildCounterNoop(context, {currentLength, isFocused, maxLength}) =>
    null;

// WARN: suffix size selected for particular values g, ml
// TODO: make suffix size is more generic
class NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final TextAlign textAlign;
  final String prefix;
  final String suffix;
  final double width;
  final Function(String) changeObserver;

  const NumberInput(
      {Key key,
      this.controller,
      this.textAlign = TextAlign.end,
      this.prefix = '',
      this.suffix = '',
      this.width,
      this.changeObserver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        buildCounter: _buildCounterNoop,
        decoration: InputDecoration(
          prefixText: prefix,
          suffix: SizedBox(
              width: 20.0,
              child: Text(suffix, style: Theme.of(context).textTheme.caption)),
        ),
        keyboardType: TextInputType.number,
        maxLength: 5,
        textAlign: textAlign,
        onChanged: changeObserver,
      ),
    );
  }
}

// Example for the future use
// typedef TextField Input(
//     {TextEditingController controller,
//     InputDecoration decoration,
//     TextAlign textAlign,
//     Function(String) changeObserver});

// Input input(TextInputType type) => (
//         {TextEditingController controller,
//         InputDecoration decoration,
//         TextAlign textAlign,
//         Function(String) changeObserver}) =>
//     TextField(
//       controller: controller,
//       buildCounter: buildCounterNoop,
//       decoration: decoration,
//       keyboardType: type,
//       maxLength: 5,
//       textAlign: textAlign,
//       onChanged: changeObserver,
//     );
