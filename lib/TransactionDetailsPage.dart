import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_bloc.dart';
import 'transaction_model.dart';
import 'LoanApplicationPage.dart'; 

class TransactionDetailsPage extends StatelessWidget {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text('MoneyApp', style: TextStyle(color: Colors.white, fontSize: 14)), 
        ),
        backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoanApplicationPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], 
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
      
            final transaction = state.transactions.isNotEmpty ? state.transactions.last : null;

          
            if (transaction == null) {
              return const Center(child: Text('No transactions available.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTransactionHeader(transaction),
                const SizedBox(height: 30),
                _buildActionButton(context, 'Add receipt', Icons.receipt, null),
                const SizedBox(height: 50),

            
                const Text('SHARE THE COST', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 10), 
                
                _buildActionButton(
                  context,
                  'Split this bill',
                  Icons.money_off,
                  () {
                    if (transaction.type == 'PAYMENT') {
                      BlocProvider.of<TransactionCubit>(context).splitTheBill(transaction);
                    }
                  },
                ),
                const SizedBox(height: 50),
                const Text('SUBSCRIPTION', style: TextStyle(fontSize: 13)), 
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4),
                    ],
                  ),
                  child: SwitchListTile(
                    title: const Text('Repeating payment'),
                    value: transaction.isRepeated || state.repeatPayment, 
                    onChanged: (value) {
                      BlocProvider.of<TransactionCubit>(context).toggleRepeatPayment();
                    },
                  ),
                ),
                const SizedBox(height: 50),
                Center( 
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("Help is on the way, stay put!"),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Something wrong? Get help',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 85),
                Center( 
                  child: Column(
                    children: [
                      Text('Transaction ID: ${transaction.id}'),
                      Text('${transaction.name} - Merchant ID #1245'),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionHeader(Transaction transaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shopping_bag, color: Color.fromRGBO(196, 20, 166, 1), size: 72), 
            const SizedBox(height: 5), 
            Text(transaction.name, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 5), 
            Text(
              '${transaction.createdAt.day} ${transaction.createdAt.month} ${transaction.createdAt.year}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        Column( 
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction.amount.toStringAsFixed(2),
              style: const TextStyle(fontSize: 32, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, 
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromRGBO(196, 20, 166, 1)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 16)), 
          ],
        ),
      ),
    );
  }
}
