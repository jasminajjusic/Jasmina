import 'package:flutter/material.dart';
import 'WhoPage.dart'; 

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  String _inputAmount = "100"; 
  bool _hasStartedTyping = false; 

  void _onKeyTapped(String value) {
    setState(() {
      if (!_hasStartedTyping) {
        _inputAmount = '';
        _hasStartedTyping = true; 
      }
      
      if (value == '⌫') {
        if (_inputAmount.isNotEmpty) {
          _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        }
      } else {
        _inputAmount += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(196, 20, 166, 1), 
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(child: Text('MoneyApp', style: TextStyle(color: Colors.white))),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white), 
            onPressed: () {
              Navigator.pop(context); 
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40), 
            Column(
              children: [
                const Text(
                  'How much?',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60), 
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '£ ', 
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: _inputAmount.isEmpty ? '0' : _inputAmount.split('.')[0],
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: _inputAmount.isEmpty ? '.00' : '.00', 
                        style: const TextStyle(
                          fontSize: 24, 
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), 
            _buildNumberPad(), 
            const SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(_inputAmount) ?? 0.0;
                if (amount > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WhoPage(amount: amount),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.5), 
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), 
                ),
              ),
              child: const Text('Next', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(height:30),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        _buildRow(['4', '5', '6']),
        _buildRow(['7', '8', '9']),
        _buildRow(['.', '0', '⌫']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKey(key)).toList(),
    );
  }

  Widget _buildKey(String value) {
    return GestureDetector(
      onTap: () => _onKeyTapped(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, 
            ),
          ),
        ),
      ),
    );
  }
}
