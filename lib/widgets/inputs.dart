import 'package:flutter/material.dart';

Widget _buildCounterNoop(context, {currentLength, isFocused, maxLength}) =>
    null;

// WARN: suffix size selected for particular values g, ml
// TODO: make suffix size is more generic
class NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String prefix;
  final String suffix;
  final TextAlign textAlign;
  final double width;
  final Function(String) onChanged;

  const NumberInput(
      {Key key,
      this.controller,
      this.prefix = '',
      this.suffix = '',
      this.textAlign = TextAlign.start,
      this.width,
      this.onChanged})
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
        onChanged: onChanged,
      ),
    );
  }
}
