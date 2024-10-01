import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_bloc.dart';
import 'transaction_model.dart';
import 'PayPage.dart'; 
import 'TopUpPage.dart'; 

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], 
        ),
        child: Column(
          children: [
            _buildTopSection(context), 
            Expanded(child: TransactionsList()), 
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Stack(
      children: [
    
        Container(
          height: 230, 
          decoration: BoxDecoration(
            color: const Color.fromRGBO(196, 20, 166, 1), 
          ),
        ),
      
        Column(
          children: [
            _buildHeader(),
            BalanceWidget(),
            ActionIconsBox(), 
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
      alignment: Alignment.center,
      child: Text(
        'MoneyApp',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '£${state.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class ActionIconsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), 
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionIcon(Icons.payment, 'Pay', context, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PayPage()),
              );
            }), 
            _buildActionIcon(Icons.account_balance_wallet, 'Top up', context, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TopUpPage()), 
              );
            }), 
            _buildActionIcon(Icons.money, 'Loan', context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, BuildContext context, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, 
      child: Column(
        children: [
          Icon(icon, size: 36, color:const Color.fromRGBO(196, 20, 166, 1)),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        Map<String, List<Transaction>> groupedTransactions = {};
        for (var transaction in state.transactions) {
          String groupKey;
          if (transaction.createdAt.isToday()) {
            groupKey = 'TODAY';
          } else if (transaction.createdAt.isYesterday()) {
            groupKey = 'YESTERDAY';
          } else {
            groupKey = transaction.createdAt.toString().substring(0, 10); 
          }
          if (groupedTransactions[groupKey] == null) {
            groupedTransactions[groupKey] = [];
          }
          groupedTransactions[groupKey]!.add(transaction);
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: groupedTransactions.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    entry.key,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ...entry.value.map((transaction) {
                  return _buildTransactionItem(transaction);
                }).toList(),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(transaction.type == 'TOP-UP' ? Icons.arrow_upward : Icons.arrow_downward,
                  color: transaction.type == 'TOP-UP' ? Colors.green : Colors.red),
              SizedBox(width: 10),
              Text(
                transaction.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            transaction.type == 'TOP-UP'
                ? '+£${transaction.amount.toStringAsFixed(2)}'
                : '-£${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: transaction.type == 'TOP-UP' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool isToday() => this.year == DateTime.now().year && this.month == DateTime.now().month && this.day == DateTime.now().day;

  bool isYesterday() => this.year == DateTime.now().year && this.month == DateTime.now().month && this.day == DateTime.now().day - 1;
}
