import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculatrice',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        fontFamily: 'Roboto',
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _operator = '';
  double? _firstNumber;
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _operator = '';
        _firstNumber = null;
        _shouldResetDisplay = false;
        return;
      }

      if (value == '⌫') {
        if (_display.length <= 1 || _display == 'Erreur') {
          _display = '0';
        } else {
          _display = _display.substring(0, _display.length - 1);
        }
        return;
      }

      if (value == '+/-') {
        if (_display != '0' && _display != 'Erreur') {
          _display = _display.startsWith('-') ? _display.substring(1) : '-$_display';
        }
        return;
      }

      if (value == '%') {
        final number = double.tryParse(_display);
        if (number != null) {
          _display = _formatNumber(number / 100);
        }
        return;
      }

      if (['+', '-', '×', '÷'].contains(value)) {
        _firstNumber = double.tryParse(_display);
        _operator = value;
        _shouldResetDisplay = true;
        return;
      }

      if (value == '=') {
        _calculateResult();
        return;
      }

      if (value == '.') {
        if (_shouldResetDisplay) {
          _display = '0.';
          _shouldResetDisplay = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
        return;
      }

      if (_display == '0' || _display == 'Erreur' || _shouldResetDisplay) {
        _display = value;
        _shouldResetDisplay = false;
      } else {
        _display += value;
      }
    });
  }

  void _calculateResult() {
    final secondNumber = double.tryParse(_display);
    if (_firstNumber == null || secondNumber == null || _operator.isEmpty) {
      return;
    }

    double result;
    switch (_operator) {
      case '+':
        result = _firstNumber! + secondNumber;
        break;
      case '-':
        result = _firstNumber! - secondNumber;
        break;
      case '×':
        result = _firstNumber! * secondNumber;
        break;
      case '÷':
        if (secondNumber == 0) {
          _display = 'Erreur';
          _firstNumber = null;
          _operator = '';
          _shouldResetDisplay = true;
          return;
        }
        result = _firstNumber! / secondNumber;
        break;
      default:
        return;
    }

    _display = _formatNumber(result);
    _firstNumber = null;
    _operator = '';
    _shouldResetDisplay = true;
  }

  String _formatNumber(double number) {
    if (number.isInfinite || number.isNaN) return 'Erreur';
    if (number == number.roundToDouble()) return number.toInt().toString();
    return number.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final buttons = <String>[
      'C', '⌫', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '+/-', '0', '.', '=',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Calculatrice Flutter'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.bottomRight,
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final label = buttons[index];
                    final isOperator = ['+', '-', '×', '÷', '='].contains(label);
                    final isUtility = ['C', '⌫', '%', '+/-'].contains(label);
                    return CalculatorButton(
                      label: label,
                      isOperator: isOperator,
                      isUtility: isUtility,
                      onTap: () => _onButtonPressed(label),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.isOperator,
    required this.isUtility,
  });

  final String label;
  final VoidCallback onTap;
  final bool isOperator;
  final bool isUtility;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color foregroundColor;

    if (isOperator) {
      backgroundColor = const Color(0xFF1E3A8A);
      foregroundColor = Colors.white;
    } else if (isUtility) {
      backgroundColor = const Color(0xFFE2E8F0);
      foregroundColor = const Color(0xFF0F172A);
    } else {
      backgroundColor = Colors.white;
      foregroundColor = const Color(0xFF0F172A);
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(22),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
