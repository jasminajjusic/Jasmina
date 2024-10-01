import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp3/main.dart';
import 'package:moneyapp3/transactions_page.dart';
import 'transaction_bloc.dart';
import 'transaction_model.dart';
import 'package:uuid/uuid.dart'; 

class WhoPage extends StatelessWidget {
  final double amount;

  WhoPage({required this.amount});

  final TextEditingController _nameController = TextEditingController();

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
              'To whom?', 
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
                controller: _nameController,
                style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  hintText: '',
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
    
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                  final String name = _nameController.text;
                  if (name.isNotEmpty) {
      
                    final String transactionId = Uuid().v4();

          
                    final newTransaction = Transaction(
                      id: transactionId, 
                      name: name,
                      amount: amount,
                      createdAt: DateTime.now(),
                      type: 'PAYMENT',
                    );

            
                    context.read<TransactionCubit>().addTransaction(newTransaction);

                
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
            
                  ),
                ),
                child: SizedBox(
                  width: 75, 
                  child: Center(
                    child: Text('Pay', style: TextStyle(color: const Color.fromRGBO(196, 20, 166, 1), fontSize: 18)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
