import 'package:coffee_badger/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:coffee_badger/ratio/ratio.dart';

// Ratio state change  -- invokes --> water state calculation and water UI update
// Coffee state change -- invokes --> water state calculation and water UI update
// Water state change  -- invokes --> coffee state calculation and coffee UI update

const double _DEFAULT_RATIO = 16.0;
const double _DEFAULT_COMPOUND_COFFEE_RATIO = 60.0;
const double _DEFAULT_COMPOUND_WATER_RATIO = 1000.0;

// TODO: consider moving it to the shared UI constants
const double _INPUT_WIDTH = 80.0;
const double _LIST_ROW_HEIGHT = 80.0;
const EdgeInsetsGeometry _LIST_VIEW_PADDING =
    EdgeInsets.symmetric(horizontal: 24.0);

class RatioScreen extends StatefulWidget {
  @override
  _RatioScreenState createState() => _RatioScreenState();
}

class _RatioScreenState extends State<RatioScreen> {
  final coffeeController = TextEditingController();
  final waterController = TextEditingController();

  double ratio;
  double coffee;
  double water;

  @override
  void initState() {
    super.initState();

    ratio = _DEFAULT_RATIO;
    coffee = 0.0;
    water = 0.0;

    coffeeController.text = '$coffee';
    waterController.text = '$water';
  }

  @override
  void dispose() {
    coffeeController.dispose();
    waterController.dispose();
    super.dispose();
  }

  void ratioObserver(double v) {
    if (v == 0.0 || v == ratio) return;
    setState(() {
      ratio = v;
    });
    calculateWater();
  }

  void onCoffeeInputChanged(String v) {
    var value = double.tryParse(v) ?? 0.0;
    if (value == 0.0 || value == coffee) return;
    setState(() {
      coffee = value;
    });
    calculateWater();
  }

  void onWaterInputChanged(String v) {
    var value = double.tryParse(v) ?? 0.0;
    if (value == 0.0 || value == water) return;
    setState(() {
      water = value;
    });
    calculateCoffee();
  }

  void calculateCoffee() {
    final v = coffeePerWater(ratio: ratio, water: water);
    setState(() {
      coffee = v;
    });
    notifyCoffeeStateChange(v);
  }

  void calculateWater() {
    final v = waterPerCoffee(ratio: ratio, coffee: coffee);
    setState(() {
      water = v;
    });
    notifyWaterStateChange(v);
  }

  void notifyCoffeeStateChange(double value) =>
      coffeeController.text = '${value.toStringAsFixed(1)}';

  void notifyWaterStateChange(double value) =>
      waterController.text = '${value.toStringAsFixed(1)}';

  Widget header() => Container(
      child: Center(
          child: Text('Ratio calculator',
              style: Theme.of(context).textTheme.headline4)),
      height: 200.0,
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            padding: _LIST_VIEW_PADDING,
            children: <Widget>[
              header(),
              _RatioSettings(ratioObserver: ratioObserver),
              Divider(indent: 10.0, endIndent: 10.0, height: 8.0),
              _ListRowSingleInput(
                controller: coffeeController,
                label: 'Coffee',
                suffix: 'g',
                textAlign: TextAlign.end,
                onChanged: onCoffeeInputChanged,
              ),
              _ListRowSingleInput(
                controller: waterController,
                label: 'Water',
                suffix: 'ml',
                textAlign: TextAlign.end,
                onChanged: onWaterInputChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatioSettings extends StatefulWidget {
  final void Function(double) ratioObserver;

  const _RatioSettings({Key key, this.ratioObserver}) : super(key: key);

  @override
  _RatioSettingsState createState() => _RatioSettingsState();
}

class _RatioSettingsState extends State<_RatioSettings> {
  final ratioController = TextEditingController();
  final coffeeController = TextEditingController();
  final waterController = TextEditingController();

  RatioType ratioType;
  double aRatio; // absolute ratio
  double cRatio; // compound ratio

  @override
  void initState() {
    super.initState();
    ratioType = RatioType.absolute;

    aRatio = _DEFAULT_RATIO;
    ratioController.text = '$_DEFAULT_RATIO';

    cRatio = compoundRatio(
        coffee: _DEFAULT_COMPOUND_COFFEE_RATIO,
        water: _DEFAULT_COMPOUND_WATER_RATIO);
    coffeeController.text = '$_DEFAULT_COMPOUND_COFFEE_RATIO';
    waterController.text = '$_DEFAULT_COMPOUND_WATER_RATIO';
  }

  @override
  void dispose() {
    ratioController.dispose();
    coffeeController.dispose();
    waterController.dispose();
    super.dispose();
  }

  void onRatioTypeChange(RatioType v) {
    var r = v == RatioType.absolute ? aRatio : cRatio;
    setState(() {
      ratioType = v;
    });
    widget.ratioObserver(r);
  }

  void onAbsoluteRatioChanged(String v) {
    var value = double.tryParse(v) ?? 0.0;
    if (value == 0.0) return;
    setState(() {
      aRatio = value;
    });
    widget.ratioObserver(value);
  }

  void onCompaundRatioChanged(String s) {
    var coffee = double.tryParse(coffeeController.text) ?? 0.0;
    var water = double.tryParse(waterController.text) ?? 0.0;
    if (coffee == 0.0 || water == 0.0) return;

    var r = compoundRatio(coffee: coffee, water: water);
    setState(() {
      cRatio = r;
    });
    widget.ratioObserver(r);
  }

  @override
  Widget build(BuildContext context) {
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
                  value: ratioType,
                  items: [
                    DropdownMenuItem(
                        child: Text(ratioTypes[RatioType.absolute]),
                        value: RatioType.absolute),
                    DropdownMenuItem(
                        child: Text(ratioTypes[RatioType.compound]),
                        value: RatioType.compound),
                  ],
                  onChanged: onRatioTypeChange,
                ),
              ),
            ],
          ),
          ratioType == RatioType.absolute
              ? _ListRowSingleInput(
                  controller: ratioController,
                  label: 'Ratio',
                  prefix: '1:',
                  onChanged: onAbsoluteRatioChanged,
                )
              : _CompoundRatio(
                  coffeeController: coffeeController,
                  waterController: waterController,
                  onChanged: onCompaundRatioChanged),
        ],
      ),
    );
  }
}

class _CompoundRatio extends StatelessWidget {
  // TODO: replace labels with coffee and beans icons.

  final TextEditingController coffeeController;
  final TextEditingController waterController;
  final Function(String) onChanged;

  const _CompoundRatio(
      {Key key, this.coffeeController, this.waterController, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onChanged: onChanged),
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
                onChanged: onChanged),
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
