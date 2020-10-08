import 'package:coffee_badger/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:coffee_badger/ratio/ratio.dart';

// TODO: Add widget test.
// TODO: Set focus to inputs when ratio preferences chanfed.
// TODO: Make ratio calculator header as a "hero" header with animation (https://flutter.dev/docs/cookbook/lists/floating-app-bar).
// TODO: Vertically align ratio input with the coffee and water inputs.

// Ratio state change  -- invokes --> water state calculation and water UI update
// Coffee state change -- invokes --> water state calculation and water UI update
// Water state change  -- invokes --> coffee state calculation and coffee UI update

const double _DEFAULT_RATIO = 16.0;
const double _DEFAULT_COMPOUND_COFFEE_RATIO = 60.0;
const double _DEFAULT_COMPOUND_WATER_RATIO = 1000.0;

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

  Widget divider() =>
      Container(child: Divider(indent: 10.0, endIndent: 10.0), height: 8.0);

  Widget coffeeInput() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child:
                  Text('Coffee', style: Theme.of(context).textTheme.bodyText1)),
          Flexible(
            child: NumberInput(
                controller: coffeeController,
                suffix: 'g',
                width: _INPUT_WIDTH,
                changeObserver: onCoffeeInputChanged),
          ),
        ],
      );

  Widget waterInput() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child:
                  Text('Water', style: Theme.of(context).textTheme.bodyText1)),
          Flexible(
            child: NumberInput(
                controller: waterController,
                suffix: 'ml',
                width: _INPUT_WIDTH,
                changeObserver: onWaterInputChanged),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            padding: _LIST_VIEW_PADDING,
            children: <Widget>[
              // TODO: move header outside of list view
              header(),
              _RatioSettings(ratioObserver: ratioObserver),
              divider(),
              _ListRowContainer(coffeeInput()),
              _ListRowContainer(waterInput()),
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
  RatioType ratioType;
  double aRatio; // absolute ratio
  double cRatio; // compound ratio

  @override
  void initState() {
    super.initState();
    ratioType = RatioType.absolute;
    aRatio = _DEFAULT_RATIO;
    cRatio = compoundRatio(
        coffee: _DEFAULT_COMPOUND_COFFEE_RATIO,
        water: _DEFAULT_COMPOUND_WATER_RATIO);
  }

  void onRatioTypeChange(RatioType v) {
    var r = v == RatioType.absolute ? aRatio : cRatio;
    setState(() {
      ratioType = v;
    });
    widget.ratioObserver(r);
  }

  void absoluteRatioObserver(double v) {
    if (v == 0.0) return;
    setState(() {
      aRatio = v;
    });
    widget.ratioObserver(v);
  }

  void compaundRatioObserver({double coffee, double water}) {
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
              ? _ListRowContainer(
                  _AbsoluteRatio(ratioObserver: absoluteRatioObserver))
              : _ListRowContainer(
                  _CompoundRatio(ratioObserver: compaundRatioObserver)),
        ],
      ),
    );
  }
}

class _AbsoluteRatio extends StatefulWidget {
  final Function(double) ratioObserver;

  const _AbsoluteRatio({Key key, this.ratioObserver}) : super(key: key);

  @override
  _AbsoluteRatioState createState() => _AbsoluteRatioState();
}

class _AbsoluteRatioState extends State<_AbsoluteRatio> {
  final ratioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ratioController.text = '$_DEFAULT_RATIO';
  }

  @override
  void dispose() {
    ratioController.dispose();
    super.dispose();
  }

  void onRatioChanged(String v) {
    var value = double.tryParse(v) ?? 0.0;
    widget.ratioObserver(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text('Ratio', style: Theme.of(context).textTheme.bodyText1)),
        Flexible(
          child: NumberInput(
              controller: ratioController,
              prefix: '1:',
              textAlign: TextAlign.start,
              width: _INPUT_WIDTH,
              changeObserver: onRatioChanged),
        ),
      ],
    );
  }
}

class _CompoundRatio extends StatefulWidget {
  final Function({double coffee, double water}) ratioObserver;

  const _CompoundRatio({Key key, this.ratioObserver}) : super(key: key);

  @override
  _CompoundRatioState createState() => _CompoundRatioState();
}

class _CompoundRatioState extends State<_CompoundRatio> {
  final coffeeController = TextEditingController();
  final waterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    coffeeController.text = '$_DEFAULT_COMPOUND_COFFEE_RATIO';
    waterController.text = '$_DEFAULT_COMPOUND_WATER_RATIO';
  }

  @override
  void dispose() {
    coffeeController.dispose();
    waterController.dispose();
    super.dispose();
  }

  void onRatioChange() {
    var c = double.tryParse(coffeeController.text) ?? 0.0;
    var w = double.tryParse(waterController.text) ?? 0.0;
    widget.ratioObserver(coffee: c, water: w);
  }

  // TODO: replace label with coffee and beans icons.
  Widget label(String text) => Container(
      child: Text(text, style: Theme.of(context).textTheme.bodyText1),
      width: 55.0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: NumberInput(
              controller: coffeeController,
              suffix: 'g',
              width: _INPUT_WIDTH,
              changeObserver: (String s) => onRatioChange()),
          flex: 2,
        ),
        label('Coffee'),
        Text('/'),
        Flexible(
          child: NumberInput(
              controller: waterController,
              suffix: 'ml',
              width: _INPUT_WIDTH,
              changeObserver: (String s) => onRatioChange()),
          flex: 2,
        ),
        label('Water'),
      ],
    );
  }
}

// TODO: consider moving it to the shared UI constants
const double _INPUT_WIDTH = 80.0;
const double _LIST_ROW_HEIGHT = 80.0;
const EdgeInsetsGeometry _LIST_VIEW_PADDING =
    EdgeInsets.symmetric(horizontal: 24.0);

// ignore: non_constant_identifier_names
Widget _ListRowContainer(Widget child) =>
    Container(child: child, height: _LIST_ROW_HEIGHT);
