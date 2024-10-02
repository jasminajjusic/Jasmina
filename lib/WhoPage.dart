import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyapp3/main.dart';
import 'package:moneyapp3/transactions_page.dart';
import 'transaction_bloc.dart';
import 'transaction_model.dart';
import 'package:uuid/uuid.dart'; 

class WhoPage extends StatelessWidget {
  final double amount;

  WhoPage({super.key, required this.amount});

  final TextEditingController _nameController = TextEditingController();

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80), 
            const Text(
              'To whom?', 
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
        
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration(
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
            const Spacer(), 
    
            FractionallySizedBox(
              widthFactor: 1 / 3,  
              child: ElevatedButton(
                onPressed: () {
                  final String name = _nameController.text;
                  if (name.isNotEmpty) {
                    final String transactionId = const Uuid().v4();

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
                  backgroundColor: Colors.white.withOpacity(0.5), 
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0.5), 
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Center(
                  child: Text(
                    'Pay', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }
}
