import 'package:flutter/material.dart';
import 'package:coffee_badger/ratio/ratio.dart';
import 'package:provider/provider.dart';

// TODO: Add widget test.
// TODO: Split UI into components.
// TODO: Add text styling: font, size, color.
// TODO: Standartize input styling - margins, padding, size.
// TODO: Set focus to inputs when ratio preferences chanfed.
// TODO: Make ratio calculator header as a "hero" header with animation.

// Ratio state change  -- invokes --> water state calculation and water UI update
// Coffee state change -- invokes --> water state calculation and water UI update
// Water state change  -- invokes --> coffee state calculation and coffee UI update

class RatioScreen extends StatefulWidget {
  @override
  RatioScreenState createState() => RatioScreenState();
}

class RatioScreenState extends State<RatioScreen> {
  final coffeeController = TextEditingController();
  final waterController = TextEditingController();

  double ratio;
  double coffee;
  double water;

  @override
  void initState() {
    super.initState();

    ratio = DEFAULT_RATIO;
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
    _calculateWater();
  }

  void _onCoffeeInputChanged(String v) {
    var value = double.tryParse(v) ?? 0.0;
    _setCoffee(value);
  }

  void _onWaterInputChanged(String v) {
    var value = double.tryParse(v) ?? 0.0;
    _setWater(value);
  }

  void _calculateCoffee() {
    final v = coffeePerWater(ratio: ratio, water: water);
    setState(() {
      coffee = v;
    });
    _notifyCoffeeStateChange(v);
  }

  void _setCoffee(double v) {
    if (v == 0.0 || v == coffee) return;
    setState(() {
      coffee = v;
    });
    _calculateWater();
  }

  void _calculateWater() {
    final v = waterPerCoffee(ratio: ratio, coffee: coffee);
    setState(() {
      water = v;
    });
    _notifyWaterStateChange(v);
  }

  void _setWater(double v) {
    if (v == 0.0 || v == water) return;
    setState(() {
      water = v;
    });
    _calculateCoffee();
  }

  void _notifyCoffeeStateChange(double value) {
    coffeeController.text = '${value.toStringAsFixed(1)}';
  }

  void _notifyWaterStateChange(double value) {
    waterController.text = '${value.toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 96.0),
              Center(child: Text('Ratio calculator')),
              SizedBox(height: 100.0),
              RatioSettings(ratioObserver: ratioObserver),
              SizedBox(height: 6.0),
              Divider(indent: 10.0, endIndent: 10.0),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Coffee'),
                  Container(
                    width: 70.0,
                    child: TextField(
                      autofocus: true,
                      controller: coffeeController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6200EE)),
                        ),
                        suffixText: 'g',
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      onChanged: _onCoffeeInputChanged,
                    ),
                  ),
                ],
              ),
              ////////////////////////////////////////////////////////////////
              SizedBox(height: 12.0),
              ////////////////////////////////////////////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Water'),
                  Container(
                    width: 70.0,
                    child: TextField(
                      controller: waterController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6200EE)),
                        ),
                        suffixText: 'ml',
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      onChanged: _onWaterInputChanged,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}

class RatioSettings extends StatefulWidget {
  final void Function(double) ratioObserver;

  const RatioSettings({Key key, this.ratioObserver}) : super(key: key);

  @override
  RatioSettingsState createState() => RatioSettingsState();
}

class RatioSettingsState extends State<RatioSettings> {
  RatioType ratioType;
  double aRatio; // absolute ratio
  double cRatio; // compound ratio

  @override
  void initState() {
    super.initState();
    ratioType = RatioType.absolute;
    aRatio = DEFAULT_RATIO;
    cRatio = compoundRatio(
        coffee: DEFAULT_COMPOUND_COFFEE_RATIO,
        water: DEFAULT_COMPOUND_WATER_RATIO);
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
              Text('Set ratio as'),
              Container(
                width: 160.0,
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
              ? AbsoluteRatio(ratioObserver: absoluteRatioObserver)
              : CompoundRatio(ratioObserver: compaundRatioObserver),
        ],
      ),
    );
  }
}

class AbsoluteRatio extends StatefulWidget {
  final Function(double) ratioObserver;

  const AbsoluteRatio({Key key, this.ratioObserver}) : super(key: key);

  @override
  AbsoluteRatioState createState() => AbsoluteRatioState();
}

class AbsoluteRatioState extends State<AbsoluteRatio> {
  final ratioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ratioController.text = '$DEFAULT_RATIO';
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
        Text('Ratio'),
        Container(
          width: 70.0,
          child: TextField(
            autofocus: true,
            controller: ratioController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),
              prefixText: '1:',
            ),
            keyboardType: TextInputType.number,
            onChanged: onRatioChanged,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class CompoundRatio extends StatefulWidget {
  final Function({double coffee, double water}) ratioObserver;

  const CompoundRatio({Key key, this.ratioObserver}) : super(key: key);

  @override
  CompoundRatioState createState() => CompoundRatioState();
}

class CompoundRatioState extends State<CompoundRatio> {
  final coffeeController = TextEditingController();
  final waterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    coffeeController.text = '$DEFAULT_COMPOUND_COFFEE_RATIO';
    waterController.text = '$DEFAULT_COMPOUND_WATER_RATIO';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextField(
            autofocus: true,
            controller: coffeeController,
            buildCounter: buildCounterNoop,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),
              suffixText: 'g',
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.end,
            onChanged: (String s) => onRatioChange(),
          ),
          flex: 2,
        ),
        Text('Coffee'),
        Flexible(
          child: Text('/'),
          flex: 1,
        ),
        Flexible(
          child: TextField(
            controller: waterController,
            buildCounter: buildCounterNoop,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6200EE)),
              ),
              suffixText: 'ml',
            ),
            keyboardType: TextInputType.number,
            maxLength: 5,
            textAlign: TextAlign.end,
            onChanged: (String s) => onRatioChange(),
          ),
          flex: 2,
        ),
        Text('Water'),
      ],
    );
  }
}

Widget buildCounterNoop(context, {currentLength, isFocused, maxLength}) => null;
