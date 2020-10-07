import 'package:flutter/material.dart';

Widget buildCounterNoop(context, {currentLength, isFocused, maxLength}) => null;

// WARN: suffix size selected for particular values g, ml
// TODO: make suffix size is more generic
InputDecoration decoration({String prefix = '', String suffix = ''}) {
  return InputDecoration(
    border: InputBorder.none,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6200EE)),
    ),
    prefixText: prefix,
    suffix: SizedBox(width: 20.0, child: Text(suffix)),
  );
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

Widget numberInput(
        {TextEditingController controller,
        InputDecoration decoration,
        TextAlign textAlign = TextAlign.end,
        Function(String) changeObserver}) =>
    TextField(
      controller: controller,
      buildCounter: buildCounterNoop,
      decoration: decoration,
      keyboardType: TextInputType.number,
      maxLength: 5,
      textAlign: textAlign,
      onChanged: changeObserver,
    );
