import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_model.dart'; 


class BalanceState {
  final double balance;

  BalanceState({required this.balance});
}

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit() : super(BalanceState(balance: 150.25));


  void updateBalance(double amount) {
    emit(BalanceState(balance: state.balance + amount));
  }

  void topUp(double amount) {}
}


class TransactionState {
  final double balance;
  final List<Transaction> transactions;

  TransactionState({required this.balance, required this.transactions});
}


class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionState(balance: 150.25, transactions: []));

  void loadTransactions() {
    List<Transaction> transactions = [
      Transaction(id: '1', name: 'Groceries', amount: 20.0, createdAt: DateTime.now(), type: 'PAYMENT'),
      Transaction(id: '2', name: 'Top Up', amount: 50.0, createdAt: DateTime.now().subtract(Duration(days: 1)), type: 'TOP-UP'),
      Transaction(id: '3', name: 'Gas', amount: 30.0, createdAt: DateTime.now().subtract(Duration(days: 1)), type: 'PAYMENT'),
      Transaction(id: '4', name: 'Top Up', amount: 100.0, createdAt: DateTime.now().subtract(Duration(days: 2)), type: 'TOP-UP'),
    ];

  
    emit(TransactionState(balance: state.balance, transactions: transactions));
  }

  
  void addTransaction(Transaction transaction) {
    
    final updatedTransactions = List<Transaction>.from(state.transactions)..add(transaction);


    double updatedBalance = state.balance;
    if (transaction.type == 'PAYMENT') {
      updatedBalance -= transaction.amount; 
    } else if (transaction.type == 'TOP-UP') {
      updatedBalance += transaction.amount; 
    }

  
    emit(TransactionState(balance: updatedBalance, transactions: updatedTransactions));
  }
}
