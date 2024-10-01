import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp3/main.dart';
import 'package:moneyapp3/transactions_page.dart';
import 'transaction_bloc.dart';
import 'transaction_model.dart';
import 'package:uuid/uuid.dart'; 

class TopUpPage extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80), 
            Text(
              'How much?', 
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80),
          
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number, 
                style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Amount',
                  hintStyle: TextStyle(color: Colors.white60),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), 
                  ),
                ),
                textAlign: TextAlign.center, 
              ),
            ),
            Spacer(), 
            ElevatedButton(
              onPressed: () {
                final String amountText = _amountController.text;
                final double? amount = double.tryParse(amountText); 

                if (amount != null && amount > 0) {
          
                  final String transactionId = Uuid().v4();

                
                  final newTransaction = Transaction(
                    id: transactionId, 
                    name: 'Top Up',
                    amount: amount,
                    createdAt: DateTime.now(),
                    type: 'TOP-UP',
                  );

                  
                  context.read<TransactionCubit>().addTransaction(newTransaction);

          
                  context.read<BalanceCubit>().topUp(amount);

                
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => TransactionsPage()), 
                    (Route<dynamic> route) => false, 
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200], 
                padding: EdgeInsets.symmetric(vertical: 16), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), 
                ),
              ),
              child: Text('Top-up', style: TextStyle(color:const Color.fromRGBO(196, 20, 166, 1), fontSize: 18)),
            ),
            SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
