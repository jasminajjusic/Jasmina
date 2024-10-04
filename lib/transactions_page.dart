import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_bloc.dart';
import 'transaction_model.dart';
import 'PayPage.dart';
import 'TransactionDetailsPage.dart';
import 'TopUpPage.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

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
          decoration: const BoxDecoration(
            color: Color.fromRGBO(196, 20, 166, 1), 
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
      child: const Text(
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
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: '£', 
                      style: TextStyle(
                        fontSize: 24, 
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: state.balance.toStringAsFixed(0), 
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: '.${state.balance.toStringAsFixed(2).split('.')[1]}',
                      style: const TextStyle(
                        fontSize: 24, 
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class ActionIconsBox extends StatelessWidget {
  const ActionIconsBox({super.key});

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
              offset: const Offset(0, 5),
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
            _buildActionIcon(Icons.money, 'Loan', context, onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionDetailsPage()),
              );
            }),
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
          Icon(icon, size: 36, color: const Color.fromARGB(255, 5, 0, 4)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

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
                if (entry.key == 'TODAY')
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Recent Activity',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey), 
                  ),
                ),
                _buildGroupedTransactionItem(entry.value),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildGroupedTransactionItem(List<Transaction> transactions) {
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: transactions.map((transaction) {
          String amount = transaction.amount.toStringAsFixed(2);
          String wholePart = amount.split('.')[0]; 
          String decimalPart = amount.split('.')[1]; 
          
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_atm, 
                          color: transaction.type == 'TOP-UP' ? Colors.green : Colors.red),
                      const SizedBox(width: 10),
                      Text(
                        transaction.name,
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,  
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${transaction.type == 'TOP-UP' ? '+' : '-'}$wholePart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: transaction.type == 'TOP-UP' ? Colors.pink : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '.$decimalPart',  
                          style: const TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),  
            ],
          );
        }).toList(),
      ),
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool isToday() => year == DateTime.now().year && month == DateTime.now().month && day == DateTime.now().day;

  bool isYesterday() => year == DateTime.now().year && month == DateTime.now().month && day == DateTime.now().day - 1;
}