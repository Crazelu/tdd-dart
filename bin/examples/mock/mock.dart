import '../user_dao.dart';
import 'mock_symbol.dart';

List<MockSymbol> _calls = [];
Map<MockSymbol, Object?> _invocationResults = {};
_WhenCall? _whenCall;
bool _verifyCalled = false;
int? _verificationCount;
MockSymbol? _verificationSymbol;

class Mock {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    final symbol = MockSymbol.fromInvocation(invocation);

    if (_verifyCalled) {
      _verificationSymbol = symbol;
      return _invocationResults[symbol] ??
          _defaultReturnValue(invocation.memberName);
    }

    _whenCall = _WhenCall(symbol);
    final result = _invocationResults[symbol];
    if (result != null) {
      if (!_verifyCalled) _calls.add(symbol);
      return result;
    }

    return _defaultReturnValue(invocation.memberName);
  }

  dynamic _defaultReturnValue(Symbol symbol) {
    switch (symbol) {
      case Symbol("getUsers"):
        return Future.value(<User>[]);

      case Symbol("addUser"):
        return Future.value();
      case Symbol("getUser"):
        return Future.value(
          User(id: 1, name: ""),
        );
      case Symbol("removeUser"):
        return Future.value();
      case Symbol("updateUser"):
        return Future.value();
    }
  }
}

Expectation<T> Function<T>(T _) get when {
  return <T>(_) {
    return Expectation<T>();
  };
}

class _WhenCall<T> {
  final MockSymbol symbol;

  _WhenCall(this.symbol);

  void _setValue(T value) {
    _invocationResults[symbol] = value;
  }
}

class Expectation<T> {
  void thenReturn(T expected) {
    if (_whenCall != null) {
      _whenCall!._setValue(expected);
    }
  }
}

Function<T>(T _, int n) get verifyN {
  _verifyCalled = true;

  return <T>(_, n) {
    _verificationCount = n;
    final callCount = _calls.where((s) => s == _verificationSymbol).length;
    if (callCount == _verificationCount) {
      print(
          "Test Passed\n${_verificationSymbol?.constructCall()} called ${_formatCountLabel(callCount, 'time')}");
    } else {
      print(
          "Test Failed\nExpected: ${_verificationSymbol?.constructCall()} called ${_formatCountLabel(n, 'time')}\nActual: ${_verificationSymbol?.constructCall()} called ${_formatCountLabel(callCount, 'time')}");
    }

    _verifyCalled = false;
    _verificationCount = null;
    _verificationSymbol = null;
  };
}

String _formatCountLabel(int count, String label) {
  if (count == 1) return "once";
  return "$count ${label}s";
}
