import 'package:coffee_badger/ratio/use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock.dart';

void main() {
  group('Ratio use case', () {
    test('updates ratio value when ratio type changed', () {
      final useCase = RatioUseCase(
          absoluteRatio: 10, compoundRatioCoffee: 50, compoundRatioWater: 1000);

      expect(useCase.ratio, 10);
      expect(useCase.activeRatio, RatioType.absolute);

      useCase.setRatioType(RatioType.compound);

      expect(useCase.activeRatio, RatioType.compound);
      expect(useCase.ratio, 20);
    });

    test(
        'does not update absolute ratio when current ratio type is not absolute',
        () {
      final useCase = RatioUseCase(
          compoundRatioCoffee: 50,
          compoundRatioWater: 1000,
          activeRatio: RatioType.compound);

      expect(useCase.ratio, 20);
      expect(useCase.activeRatio, RatioType.compound);

      useCase.setRatio(15);

      expect(useCase.ratio, 20);
      expect(useCase.activeRatio, RatioType.compound);
    });

    test('updates absolute ratio', () {
      final useCase = RatioUseCase(
          absoluteRatio: 10, compoundRatioCoffee: 50, compoundRatioWater: 1000);

      expect(useCase.ratio, 10);
      expect(useCase.activeRatio, RatioType.absolute);

      useCase.setRatio(15);

      expect(useCase.ratio, 15);
      expect(useCase.activeRatio, RatioType.absolute);
    });

    test(
        'does not update compaund ratio when current ratio type is not compound',
        () {
      final useCase = RatioUseCase();

      expect(useCase.ratio, 16);
      expect(useCase.activeRatio, RatioType.absolute);

      useCase.setCompoundRatio(RatioParameter.coffee)(60);

      expect(useCase.ratio, 16);
      expect(useCase.activeRatio, RatioType.absolute);
    });

    test('updates compaund ratio', () {
      final useCase = RatioUseCase(
          absoluteRatio: 10,
          compoundRatioCoffee: 50,
          compoundRatioWater: 1000,
          activeRatio: RatioType.compound);

      expect(useCase.ratio, 20);
      expect(useCase.activeRatio, RatioType.compound);

      useCase.setCompoundRatio(RatioParameter.coffee)(60);

      expect(useCase.ratio, closeTo(16.666, 0.001));
      expect(useCase.activeRatio, RatioType.compound);
    });

    test('updates brew water after new brew coffee set', () {
      final useCase = RatioUseCase(absoluteRatio: 10);

      expect(useCase.brewCoffee, 0);
      expect(useCase.brewWater, 0);

      useCase.setBrew(BrewParameter.coffee)(15);

      expect(useCase.brewCoffee, 15);
      expect(useCase.brewWater, 150);
    });

    test('updates brew water after new ratio set', () {
      final useCase = RatioUseCase(
          absoluteRatio: 10, compoundRatioCoffee: 50, compoundRatioWater: 1000);

      expect(useCase.brewCoffee, 0);
      expect(useCase.brewWater, 0);

      useCase.setBrew(BrewParameter.coffee)(17);

      expect(useCase.brewCoffee, 17);
      expect(useCase.brewWater, 170);

      useCase.setRatioType(RatioType.compound);

      expect(useCase.brewCoffee, 17);
      expect(useCase.brewWater, 340);
    });

    test('updates brew coffee after new brew water set', () {
      final useCase = RatioUseCase(absoluteRatio: 10);

      expect(useCase.brewCoffee, 0);
      expect(useCase.brewWater, 0);

      useCase.setBrew(BrewParameter.water)(160);

      expect(useCase.brewCoffee, 16);
      expect(useCase.brewWater, 160);
    });

    group('onRatioChange', () {
      test('called when ratio type changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(
            absoluteRatio: 10,
            compoundRatioCoffee: 50,
            compoundRatioWater: 1000,
            onRatioChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setRatioType(RatioType.compound);
        expect(mock.calledOnce, true);
        expect(mock.calledWith(20), true);
      });

      test('called when absolute ratio changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(absoluteRatio: 10, onRatioChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setRatio(12);
        expect(mock.calledOnce, true);
        expect(mock.calledWith(12), true);
      });

      test('called when compound ratio coffee changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(
            compoundRatioCoffee: 50,
            compoundRatioWater: 1000,
            activeRatio: RatioType.compound,
            onRatioChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setCompoundRatio(RatioParameter.coffee)(60);
        expect(mock.calledOnce, true);
        expect(mock.callArgs, closeTo(16.666, 0.001));
      });

      test('called when compound ratio water changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(
            compoundRatioCoffee: 50,
            compoundRatioWater: 1000,
            activeRatio: RatioType.compound,
            onRatioChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setCompoundRatio(RatioParameter.water)(1100);
        expect(mock.calledOnce, true);
        expect(mock.callArgs, 22);
      });
    });

    group('onCoffeeChange', () {
      test('called when brew water changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(onCoffeeChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setBrew(BrewParameter.water)(160);
        expect(mock.calledOnce, true);
        expect(mock.callArgs, 10);
      });
    });

    group('onWaterChange', () {
      test('called when brew coffee changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(onWaterChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setBrew(BrewParameter.coffee)(15);
        expect(mock.calledOnce, true);
        expect(mock.callArgs, 240);
      });

      test('called when ratio type changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(onWaterChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setBrew(BrewParameter.coffee)(15);
        useCase.setRatioType(RatioType.compound);
        expect(mock.calledTimes(2), true);
        expect(mock.nthCallArgs(2), closeTo(250, 0.001));
      });

      test('called when absolute ratio changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(onWaterChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setBrew(BrewParameter.coffee)(15);
        useCase.setRatio(14);
        expect(mock.calledTimes(2), true);
        expect(mock.nthCallArgs(2), 210);
      });

      test('called when compound ratio coffee changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(
            activeRatio: RatioType.compound, onWaterChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setBrew(BrewParameter.coffee)(15);
        useCase.setCompoundRatio(RatioParameter.coffee)(55);
        expect(mock.calledTimes(2), true);
        expect(mock.nthCallArgs(2), closeTo(272.727, 0.001));
      });

      test('called when compound ratio water changed', () {
        Mock mock = Mock();

        final useCase = RatioUseCase(
            activeRatio: RatioType.compound, onWaterChange: mock.fn);

        expect(mock.notCalled, true);
        useCase.setBrew(BrewParameter.coffee)(15);
        useCase.setCompoundRatio(RatioParameter.water)(1300);
        expect(mock.calledTimes(2), true);
        expect(mock.nthCallArgs(2), 325);
      });
    });
  });
}
