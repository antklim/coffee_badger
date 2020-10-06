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

  void notifyCoffeeStateChange(double value) {
    coffeeController.text = '${value.toStringAsFixed(1)}';
  }

  void notifyWaterStateChange(double value) {
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
              ...header(),
              RatioSettings(ratioObserver: ratioObserver),
              ...divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Coffee'),
                  Container(
                    width: 70.0,
                    child: numberInput(
                        controller: coffeeController,
                        decoration: decoration(suffix: 'g'),
                        changeObserver: onCoffeeInputChanged),
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
                    child: numberInput(
                        controller: waterController,
                        decoration: decoration(suffix: 'ml'),
                        changeObserver: onWaterInputChanged),
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
          child: numberInput(
              controller: ratioController,
              decoration: decoration(prefix: '1:'),
              textAlign: TextAlign.start,
              changeObserver: onRatioChanged),
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
          child: numberInput(
              controller: coffeeController,
              decoration: decoration(suffix: 'g'),
              changeObserver: (String s) => onRatioChange()),
          flex: 2,
        ),
        Text('Coffee'),
        Flexible(
          child: Text('/'),
          flex: 1,
        ),
        Flexible(
          child: numberInput(
              controller: waterController,
              decoration: decoration(suffix: 'ml'),
              changeObserver: (String s) => onRatioChange()),
          flex: 2,
        ),
        Text('Water'),
      ],
    );
  }
}

Widget buildCounterNoop(context, {currentLength, isFocused, maxLength}) => null;

InputDecoration decoration({String prefix = '', String suffix = ''}) {
  return InputDecoration(
    border: InputBorder.none,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6200EE)),
    ),
    prefixText: prefix,
    // prefix: SizedBox(width: 32, child: Text(prefix)),
    suffixText: suffix,
    // suffix: SizedBox(width: 32, child: Text(suffix)),
  );
}

TextField numberInput(
    {TextEditingController controller,
    InputDecoration decoration,
    TextAlign textAlign = TextAlign.end,
    Function(String) changeObserver}) {
  return TextField(
    controller: controller,
    buildCounter: buildCounterNoop,
    decoration: decoration,
    keyboardType: TextInputType.number,
    maxLength: 5,
    textAlign: textAlign,
    onChanged: changeObserver,
  );
}

List<Widget> header() {
  return <Widget>[
    SizedBox(height: 96.0),
    Center(child: Text('Ratio calculator')),
    SizedBox(height: 100.0),
  ];
}

List<Widget> divider() {
  return <Widget>[
    SizedBox(height: 6.0),
    Divider(indent: 10.0, endIndent: 10.0),
    SizedBox(height: 12.0),
  ];
}
