import 'package:coffee_badger/ratio/state.dart';
import 'package:flutter/material.dart';
import 'package:coffee_badger/widgets/widgets.dart';
import 'package:coffee_badger/ratio/use_case.dart';
import 'package:provider/provider.dart';

// TODO: in compound ratio settings replace labels with coffee and beans icons.

// Ratio state change  -- invokes --> water state calculation and water UI update
// Coffee state change -- invokes --> water state calculation and water UI update
// Water state change  -- invokes --> coffee state calculation and coffee UI update

// TODO: consider moving it to the shared UI constants
const double _INPUT_WIDTH = 80.0;
const double _LIST_ROW_HEIGHT = 80.0;
const EdgeInsetsGeometry _LIST_VIEW_PADDING =
    EdgeInsets.symmetric(horizontal: 24.0);

class RatioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RatioState>(
      create: (_) => RatioState(),
      builder: (context, _) {
        return Scaffold(
          body: Container(
            child: SafeArea(
              child: ListView(
                padding: _LIST_VIEW_PADDING,
                children: <Widget>[
                  _Header(),
                  _RatioSettings(),
                  Divider(indent: 10.0, endIndent: 10.0, height: 8.0),
                  _BrewSettings(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text('Ratio calculator',
              style: Theme.of(context).textTheme.headline4)),
      height: 200.0,
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
    );
  }
}

class _RatioSettings extends StatefulWidget {
  @override
  _RatioSettingsState createState() => _RatioSettingsState();
}

class _RatioSettingsState extends State<_RatioSettings> {
  final ratioTypes = <RatioType, String>{
    RatioType.absolute: 'Absolute value',
    RatioType.compound: 'Coffee per water'
  };

  @override
  Widget build(BuildContext context) {
    RatioState state = Provider.of<RatioState>(context);

    return Container(
      child: ListBody(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text('Set ratio as',
                      style: Theme.of(context).textTheme.bodyText1)),
              Flexible(
                child: DropdownButton<RatioType>(
                  value: state.activeRatio,
                  items: ratioTypes.entries
                      .map((entry) => DropdownMenuItem(
                          child: Text(entry.value), value: entry.key))
                      .toList(),
                  onChanged: state.setRatioType,
                ),
              ),
            ],
          ),
          state.activeRatio == RatioType.absolute
              ? _AbsoluteRatio()
              : _CompoundRatio()
        ],
      ),
    );
  }
}

class _AbsoluteRatio extends StatefulWidget {
  @override
  _AbsoluteRatioState createState() => _AbsoluteRatioState();
}

class _AbsoluteRatioState extends State<_AbsoluteRatio> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final RatioState state = Provider.of<RatioState>(context, listen: false);
    controller = TextEditingController(text: '${state.absoluteRatio}');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RatioState state = Provider.of<RatioState>(context);

    return _ListRowSingleInput(
      controller: controller,
      label: 'Ratio',
      prefix: '1:',
      onChanged: state.setRatio,
    );
  }
}

class _CompoundRatio extends StatefulWidget {
  @override
  _CompoundRatioState createState() => _CompoundRatioState();
}

class _CompoundRatioState extends State<_CompoundRatio> {
  TextEditingController coffeeController;
  TextEditingController waterController;

  @override
  void initState() {
    super.initState();
    final RatioState state = Provider.of<RatioState>(context, listen: false);
    coffeeController =
        TextEditingController(text: '${state.compoundRatioCoffee}');
    waterController =
        TextEditingController(text: '${state.compoundRatioWater}');
  }

  @override
  void dispose() {
    coffeeController.dispose();
    waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RatioState state = Provider.of<RatioState>(context);

    return Container(
      height: _LIST_ROW_HEIGHT,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: NumberInput(
                controller: coffeeController,
                suffix: 'g',
                width: _INPUT_WIDTH,
                onChanged: state.setCompoundRatio(RatioParameter.coffee)),
            flex: 2,
          ),
          Container(
              child:
                  Text('Coffee', style: Theme.of(context).textTheme.bodyText1),
              width: 55.0),
          Text('/'),
          Flexible(
            child: NumberInput(
                controller: waterController,
                suffix: 'ml',
                width: _INPUT_WIDTH,
                onChanged: state.setCompoundRatio(RatioParameter.water)),
            flex: 2,
          ),
          Container(
              child:
                  Text('Water', style: Theme.of(context).textTheme.bodyText1),
              width: 55.0),
        ],
      ),
    );
  }
}

class _BrewSettings extends StatefulWidget {
  @override
  _BrewSettingsState createState() => _BrewSettingsState();
}

class _BrewSettingsState extends State<_BrewSettings> {
  TextEditingController coffeeController;
  TextEditingController waterController;

  @override
  void initState() {
    super.initState();
    final RatioState state = Provider.of<RatioState>(context, listen: false);
    coffeeController = TextEditingController(text: '${state.brewCoffee}');
    waterController = TextEditingController(text: '${state.brewWater}');
  }

  @override
  void dispose() {
    coffeeController.dispose();
    waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RatioState state = Provider.of<RatioState>(context);

    state.addListener(() {
      var oldCoffee = double.tryParse(coffeeController.text) ?? 0.0;
      if (oldCoffee != state.brewCoffee) {
        coffeeController.text = '${state.brewCoffee.toStringAsFixed(1)}';
      }

      var oldWater = double.tryParse(waterController.text) ?? 0.0;
      if (oldWater != state.brewWater) {
        waterController.text = '${state.brewWater.toStringAsFixed(1)}';
      }
    });

    return Container(
      child: Column(
        children: [
          _ListRowSingleInput(
            controller: coffeeController,
            label: 'Coffee',
            suffix: 'g',
            textAlign: TextAlign.end,
            onChanged: state.setBrew(BrewParameter.coffee),
          ),
          _ListRowSingleInput(
            controller: waterController,
            label: 'Water',
            suffix: 'ml',
            textAlign: TextAlign.end,
            onChanged: state.setBrew(BrewParameter.water),
          ),
        ],
      ),
    );
  }
}

class _ListRowSingleInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String prefix;
  final String suffix;
  final TextAlign textAlign;
  final Function(String) onChanged;

  const _ListRowSingleInput(
      {Key key,
      this.label,
      this.controller,
      this.prefix = '',
      this.suffix = '',
      this.textAlign = TextAlign.start,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _LIST_ROW_HEIGHT,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(label, style: Theme.of(context).textTheme.bodyText1)),
          Flexible(
            child: NumberInput(
                controller: controller,
                prefix: prefix,
                suffix: suffix,
                textAlign: textAlign,
                width: _INPUT_WIDTH,
                onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
