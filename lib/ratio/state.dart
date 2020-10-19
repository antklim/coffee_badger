import 'package:flutter/material.dart';
import 'package:coffee_badger/ratio/use_case.dart';

class RatioState extends ChangeNotifier {
  RatioUseCase _useCase = RatioUseCase();

  RatioState() {
    _useCase = RatioUseCase(
        onRatioChange: _onRatioChange,
        onCoffeeChange: _onCoffeeChange,
        onWaterChange: _onWaterChange);
  }

  void _onRatioChange(double v) {
    notifyListeners();
  }

  void _onCoffeeChange(double v) {
    notifyListeners();
  }

  void _onWaterChange(double v) {
    notifyListeners();
  }

  RatioType get activeRatio => _useCase.activeRatio;
  double get ratio => _useCase.ratio;
  double get absoluteRatio => _useCase.absoluteRatio;
  double get compoundRatioCoffee => _useCase.compoundRatioCoffee;
  double get compoundRatioWater => _useCase.compoundRatioWater;
  double get brewCoffee => _useCase.brewCoffee;
  double get brewWater => _useCase.brewWater;

  void setRatioType(RatioType ratioType) => _useCase.setRatioType(ratioType);

  void setRatio(String v) {
    var value = double.tryParse(v) ?? 0.0;
    return _useCase.setRatio(value);
  }

  ValueChanged<String> setCompoundRatio(RatioParameter rp) => (String v) {
        var value = double.tryParse(v) ?? 0.0;
        return _useCase.setCompoundRatio(rp)(value);
      };

  ValueChanged<String> setBrew(BrewParameter bp) => (String v) {
        var value = double.tryParse(v) ?? 0.0;
        return _useCase.setBrew(bp)(value);
      };
}
