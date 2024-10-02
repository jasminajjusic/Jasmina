import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class LoanApplicationState {}

class LoanInitial extends LoanApplicationState {}

class LoanApproved extends LoanApplicationState {}

class LoanDeclined extends LoanApplicationState {}

class LoanAlreadyApplied extends LoanApplicationState {}

class LoanApplicationCubit extends Cubit<LoanApplicationState> {
  LoanApplicationCubit() : super(LoanInitial());

  
  Future<void> applyForLoan({
    required double monthlySalary,
    required double monthlyExpenses,
    required double loanAmount,
    required int loanTerm,
    required double moneyInAccount,
  }) async {
    
    final randomNumber = await _getRandomNumber();
    if (randomNumber == null) {
      emit(LoanDeclined());
      return;
    }

    
    if (moneyInAccount <= 1000) {
      emit(LoanDeclined());
      return;
    }

    
    if (monthlySalary <= 1000) {
      emit(LoanDeclined());
      return;
    }

  
    if (monthlyExpenses >= (monthlySalary / 3)) {
      emit(LoanDeclined());
      return;
    }

  
    final loanCost = loanAmount / loanTerm;
    if (loanCost >= (monthlySalary / 3)) {
      emit(LoanDeclined());
      return;
    }
    emit(LoanApproved());
  }
  Future<int?> _getRandomNumber() async {
    try {
      final response = await http.get(Uri.parse('https://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1'));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body[0];
      }
      return null;
    } catch (e) {
      print('Error generating random number: $e');
      return null;
    }
  }
}
