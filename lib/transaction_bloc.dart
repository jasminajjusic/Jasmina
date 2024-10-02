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

  void topUp(double amount) {
    updateBalance(amount); 
  }
}

class TransactionState {
  final double balance;
  final List<Transaction> transactions;
  final bool repeatPayment;

  TransactionState({
    required this.balance,
    required this.transactions,
    this.repeatPayment = false,
  });
  TransactionState copyWith({
    double? balance,
    List<Transaction>? transactions,
    bool? repeatPayment,
  }) {
    return TransactionState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      repeatPayment: repeatPayment ?? this.repeatPayment,
    );
  }
}

class TransactionCubit extends Cubit<TransactionState> {
  final BalanceCubit balanceCubit;

   TransactionCubit(this.balanceCubit) : super(TransactionState(balance: balanceCubit.state.balance, transactions: []));

  void loadTransactions() {
    List<Transaction> transactions = [
      Transaction(id: '1', name: 'Groceries', amount: 20.0, createdAt: DateTime.now(), type: 'PAYMENT'),
      Transaction(id: '2', name: 'Top Up', amount: 50.0, createdAt: DateTime.now().subtract(const Duration(days: 1)), type: 'TOP-UP'),
      Transaction(id: '3', name: 'Gas', amount: 30.0, createdAt: DateTime.now().subtract(const Duration(days: 1)), type: 'PAYMENT'),
      
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

  
    balanceCubit.updateBalance(transaction.type == 'TOP-UP' ? transaction.amount : -transaction.amount);

    emit(TransactionState(balance: updatedBalance, transactions: updatedTransactions));
  }

  void splitTheBill(Transaction transaction) {
    if (transaction.type == 'PAYMENT') {
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Split Bill: ${transaction.name}',
        amount: transaction.amount / 2,
        createdAt: DateTime.now(),
        type: 'TOP-UP',
      );

      final updatedTransactions = List<Transaction>.from(state.transactions)
        ..remove(transaction)
        ..add(transaction.copyWith(amount: transaction.amount / 2))
        ..add(newTransaction);

    
      balanceCubit.updateBalance(newTransaction.amount);

      emit(TransactionState(balance: state.balance + newTransaction.amount, transactions: updatedTransactions));
    }
  }

  void toggleRepeatPayment() {
    emit(state.copyWith(repeatPayment: !state.repeatPayment));
  }

  void addRepeatedTransaction(Transaction transaction) {
    if (state.repeatPayment && transaction.type == 'PAYMENT') {
      final repeatedTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: transaction.name,
        amount: transaction.amount,
        createdAt: DateTime.now(),
        type: 'PAYMENT',
      );

      final updatedTransactions = List<Transaction>.from(state.transactions)..add(repeatedTransaction);

      double updatedBalance = state.balance - repeatedTransaction.amount;

    
      balanceCubit.updateBalance(-repeatedTransaction.amount);

      emit(TransactionState(balance: updatedBalance, transactions: updatedTransactions));
    }
  }
}
