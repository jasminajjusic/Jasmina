import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:math';


abstract class LoanApplicationState {}

class LoanInitial extends LoanApplicationState {}

class LoanApproved extends LoanApplicationState {}

class LoanDeclined extends LoanApplicationState {
  final String reason;
  LoanDeclined(this.reason); 
}

class LoanAlreadyApplied extends LoanApplicationState {}

class LoanApplicationCubit extends Cubit<LoanApplicationState> {
  double _currentBalance = 0;
  double _monthlySalary = 0;
  double _monthlyExpenses = 0;
  double _loanAmount = 0;
  int _loanTerm = 0;

  LoanApplicationCubit() : super(LoanInitial());

  
  Future<void> applyForLoan({
    required double monthlySalary,
    required double monthlyExpenses,
    required double loanAmount,
    required int loanTerm,
    required double currentBalance, 
  }) async {
    
    _currentBalance = currentBalance;
    _monthlySalary = monthlySalary;
    _monthlyExpenses = monthlyExpenses;
    _loanAmount = loanAmount;
    _loanTerm = loanTerm;

    final randomNumber = _getRandomNumber();

    if (randomNumber < 20) {
      emit(LoanAlreadyApplied());
      return;
    }

    final decision = _checkLoanConditions(
      monthlySalary,
      monthlyExpenses,
      loanAmount,
      loanTerm,
      currentBalance,
      randomNumber,
    );

    if (decision == 'APPROVED') {
      emit(LoanApproved());
      _addLoanTransaction(loanAmount);
    } else {
      emit(LoanDeclined(decision)); 

      if (decision == 'Odbijeno zbog slučajnog broja (manji od 50)' || decision == 'Odbijeno zbog balansa na računu (manje od 1000)') {
        _listenForNewTransactions();
      }
    }
  }

  void _addLoanTransaction(double amount) {

    print('Dodajem LOAN transakciju u iznosu: $amount');

   
  }

 
  String _checkLoanConditions(
    double monthlySalary,
    double monthlyExpenses,
    double loanAmount,
    int loanTerm,
    double currentBalance,
    int randomNumber,
  ) {
    if (randomNumber <= 50) {
      return 'Odbijeno zbog slučajnog broja (manji od 50)'; 
    }

    if (currentBalance <= 1000) {
      return 'Odbijeno zbog balansa na računu (manje od 1000)'; 
    }

    if (monthlySalary <= 1000) {
      return 'Odbijeno zbog plate (manje od 1000)'; 
    }

    if (monthlyExpenses >= (monthlySalary / 3)) {
      return 'Odbijeno zbog troškova (troškovi su veći od ⅓ plate)'; 
    }

    final loanCost = loanAmount / loanTerm;
    if (loanCost >= (monthlySalary / 3)) {
      return 'Odbijeno zbog troška kredita (trošak kredita je veći od ⅓ plate)'; 
    }

    return 'APPROVED'; 
  }

 
  int _getRandomNumber() {
    final random = Random();
    return random.nextInt(101); 
  }


  void _listenForNewTransactions() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      print('Provjera novih transakcija...');

     
      _currentBalance += 500; 

      print('Ažuriran balans: $_currentBalance');

      final decision = _checkLoanConditions(
        _monthlySalary,
        _monthlyExpenses,
        _loanAmount,
        _loanTerm,
        _currentBalance,
        _getRandomNumber(),
      );

      if (decision == 'APPROVED') {
        emit(LoanApproved());
        _addLoanTransaction(_loanAmount); 
        timer.cancel(); 
      }
    });
  }
}