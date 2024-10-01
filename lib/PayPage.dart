import 'package:flutter/material.dart';
import 'WhoPage.dart'; 

class PayPage extends StatefulWidget {
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
        title: Center(child: Text('MoneyApp', style: TextStyle(color: Colors.white))),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
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
            SizedBox(height: 80),
            Column(
              children: [
                Text(
                  'How much?',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    
                  ),
                ),
                SizedBox(height: 80),
                Text(
                  _inputAmount.isEmpty ? '£ 0.00' : '£ $_inputAmount.00', 
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                   
                  ),
                ),
              ],
            ),
            Spacer(), 
            _buildNumberPad(), 
            SizedBox(height: 40), 
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
                    SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 235, 225, 228), 
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 120),
                shape: RoundedRectangleBorder(
                 
                ),
              ),
              child: Text('Next', style: TextStyle(color: const Color.fromRGBO(196, 20, 166, 1), fontSize: 18)),
            ),
            SizedBox(height: 20), 
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
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
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
