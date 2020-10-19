import 'package:coffee_badger/ratio/ratio.dart';
import 'package:flutter/material.dart';

enum BrewParameter { coffee, water }
enum RatioType { absolute, compound }
enum RatioParameter { coffee, water }

const double _DEFAULT_RATIO = 16;
const double _DEFAULT_COMPOUND_COFFEE_RATIO = 60;
const double _DEFAULT_COMPOUND_WATER_RATIO = 1000;
const double _DEFAULT_BREW_COFFEE = 0;
const double _DEFAULT_BREW_WATER = 0;

class RatioUseCase {
  final ValueChanged<double> onRatioChange;
  final ValueChanged<double> onCoffeeChange;
  final ValueChanged<double> onWaterChange;

  RatioType _activeRatio;
  double _absoluteRatio;
  double _compoundRatioCoffee;
  double _compoundRatioWater;
  double _brewCoffee;
  double _brewWater;

  RatioUseCase(
      {double absoluteRatio,
      double compoundRatioCoffee,
      double compoundRatioWater,
      RatioType activeRatio,
      this.onRatioChange,
      this.onCoffeeChange,
      this.onWaterChange}) {
    _activeRatio = activeRatio ?? RatioType.absolute;
    _absoluteRatio = absoluteRatio ?? _DEFAULT_RATIO;
    _compoundRatioCoffee =
        compoundRatioCoffee ?? _DEFAULT_COMPOUND_COFFEE_RATIO;
    _compoundRatioWater = compoundRatioWater ?? _DEFAULT_COMPOUND_WATER_RATIO;

    _brewCoffee = _DEFAULT_BREW_COFFEE;
    _brewWater = _DEFAULT_BREW_WATER;
  }

  void _setBrewCoffee(double coffee) {
    if (coffee <= 0 || _brewCoffee == coffee) return;
    _brewCoffee = coffee;
    _brewWater = waterPerCoffee(coffee: coffee, ratio: ratio);
    onWaterChange?.call(_brewWater);
  }

  void _setBrewWater(double water) {
    if (water <= 0 || _brewWater == water) return;
    _brewCoffee = coffeePerWater(water: water, ratio: ratio);
    _brewWater = water;
    onCoffeeChange?.call(_brewCoffee);
  }

  ///
  /// Notify about ratio change.
  ///
  void _ratioChanged() {
    double _ratio = ratio;
    _brewWater = waterPerCoffee(coffee: _brewCoffee, ratio: _ratio);
    onRatioChange?.call(_ratio);
    onWaterChange?.call(_brewWater);
  }

  void _setCompoundRatioCoffee(double coffee) {
    if (coffee <= 0 || _compoundRatioCoffee == coffee) return;
    _compoundRatioCoffee = coffee;
    _ratioChanged();
  }

  void _setCompoundRatioWater(double water) {
    if (water <= 0 || _compoundRatioWater == water) return;
    _compoundRatioWater = water;
    _ratioChanged();
  }

  ///
  /// User updates ratio type settings.
  ///
  void setRatioType(RatioType ratioType) {
    if (_activeRatio == ratioType) return;
    _activeRatio = ratioType;
    _ratioChanged();
  }

  ///
  /// User sets new absolute ratio.
  ///
  void setRatio(double ratio) {
    if (_activeRatio != RatioType.absolute || ratio <= 0) return;
    _absoluteRatio = ratio;
    _ratioChanged();
  }

  ///
  /// User sets parameters of compound ratio.
  ///
  ValueSetter<double> setCompoundRatio(RatioParameter ratioParameter) {
    if (ratioParameter == RatioParameter.coffee) return _setCompoundRatioCoffee;
    return _setCompoundRatioWater;
  }

  ///
  /// User sets brew parameter and value.
  ///
  ValueSetter<double> setBrew(BrewParameter brewParameter) {
    if (brewParameter == BrewParameter.coffee) return _setBrewCoffee;
    return _setBrewWater;
  }

  double get ratio => _activeRatio == RatioType.absolute
      ? _absoluteRatio
      : compoundRatio(coffee: _compoundRatioCoffee, water: _compoundRatioWater);

  RatioType get activeRatio => _activeRatio;
  double get absoluteRatio => _absoluteRatio;
  double get compoundRatioCoffee => _compoundRatioCoffee;
  double get compoundRatioWater => _compoundRatioWater;
  double get brewCoffee => _brewCoffee;
  double get brewWater => _brewWater;
}
