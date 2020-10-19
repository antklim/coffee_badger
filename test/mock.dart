class Mock {
  final List<List<double>> _calls = List<List<double>>.empty(growable: true);
  final List<double> _args = List<double>.empty(growable: true);
  Function(double) _mock;

  Mock() {
    _mock = (double v) {
      _args.add(v);
      _calls.add(_args);
    };
  }

  Function(double) get fn => _mock;

  bool get called => _calls.isNotEmpty;
  bool get notCalled => _calls.isEmpty;
  bool get calledOnce => _calls.length == 1;
  bool calledTimes(int times) => _calls.length == times;
  bool calledWith(double v) => _calls.last.last == v;
  double get callArgs => _calls.last.last;
  bool calledNthWith(int index, double v) => _calls[index - 1].last == v;
  double nthCallArgs(int index) => _calls[index - 1].last;

  // TODO: add resets
  // TODO: one mock fn should create a new instance of function
  // TODO: add comments/documentation
}
