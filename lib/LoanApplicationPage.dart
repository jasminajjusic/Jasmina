import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loan_application_cubit.dart'; 

class LoanApplicationPage extends StatelessWidget {
  final double currentBalance; 

  LoanApplicationPage({required this.currentBalance});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoanApplicationCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Loan Application',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF9B0077), 
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.grey[200], 
          child: LoanForm(currentBalance: currentBalance), 
        ),
      ),
    );
  }
}

class LoanForm extends StatefulWidget {
  final double currentBalance; 

  LoanForm({required this.currentBalance});

  @override
  _LoanFormState createState() => _LoanFormState();
}

class _LoanFormState extends State<LoanForm> {
  final TextEditingController _monthlySalaryController = TextEditingController();
  final TextEditingController _monthlyExpensesController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _loanTermController = TextEditingController();

  bool _termsAccepted = false; 

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoanApplicationCubit, LoanApplicationState>(
      listener: (context, state) {
        if (state is LoanApproved) {
          _showDialog(
            context,
            'Loan Application Approved',
            'Yeeeyyy !! Congrats. Your application has been approved. Dont tell your friends you have money!',
          );
        } else if (state is LoanDeclined) {
          _showDialog(
            context,
            'Loan Application Declined',
            'Ooopsss. Your application has been declined. It’s not your fault, it’s a financial crisis. Reason: ${state.reason}',
          );
        } else if (state is LoanAlreadyApplied) {
          _showDialog(
            context,
            'Loan Application Already Submitted',
            'Ooopsss, you applied before. Wait for notification from us',
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              _buildTermsAndConditionsText(),
              SizedBox(height: 12),

              _buildAcceptTermsSection(),
              SizedBox(height: 16),

          
              _buildAboutYouSection(),
              SizedBox(height: 10),
              _buildInputField(
                label: 'Monthly Salary',
                controller: _monthlySalaryController,
              ),
              SizedBox(height: 12),
              _buildInputField(
                label: 'Monthly Expenses',
                controller: _monthlyExpensesController,
              ),
              SizedBox(height: 16),

          
              _buildLoanSection(),
              SizedBox(height: 10),
              _buildInputField(
                label: 'Amount',
                controller: _loanAmountController,
              ),
              SizedBox(height: 12),
              _buildInputField(
                label: 'Term',
                controller: _loanTermController,
              ),
              SizedBox(height: 24),

      
              _buildApplyButton(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTermsAndConditionsText() {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Nunc vulputate libero et velit interdum, ac aliquet odio mattis. '
      'Curabitur tempus urna at turpis condimentum lobortis. '
      'Vestibulum eu nisl. Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Nunc vulputate libero et velit interdum, ac aliquet odio mattis. '
      'Curabitur tempus urna at turpis condimentum lobortis. '
      'Vestibulum eu nisl.',
      style: TextStyle(
          color: const Color.fromARGB(255, 120, 118, 118), fontSize: 14),
    );
  }

  Widget _buildAcceptTermsSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Accept Terms & Conditions',
            style: TextStyle(fontSize: 14),
          ),
          Switch(
            value: _termsAccepted,
            onChanged: (bool value) {
              setState(() {
                _termsAccepted = value;
              });
            },
            activeColor: Color(0xFF9B0077), 
          ),
        ],
      ),
    );
  }


  Widget _buildAboutYouSection() {
    return Text(
      'ABOUT YOU',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }


  Widget _buildLoanSection() {
    return Text(
      'LOAN',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildApplyButton() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3, 
        child: ElevatedButton(
          onPressed: _termsAccepted
              ? () {
                  double monthlySalary = double.tryParse(_monthlySalaryController.text) ?? 0;
                  double monthlyExpenses = double.tryParse(_monthlyExpensesController.text) ?? 0;
                  double loanAmount = double.tryParse(_loanAmountController.text) ?? 0;
                  int loanTerm = int.tryParse(_loanTermController.text) ?? 0;

                  context.read<LoanApplicationCubit>().applyForLoan(
                    monthlySalary: monthlySalary,
                    monthlyExpenses: monthlyExpenses,
                    loanAmount: loanAmount,
                    loanTerm: loanTerm,
                    currentBalance: widget.currentBalance,
                  );
                }
              : null, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF9B0077), 
            padding: EdgeInsets.symmetric(vertical: 20), 
            textStyle: TextStyle(fontSize: 16, color: Colors.white), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), 
            ),
          ),
          child: Text('Apply for loan'),
        ),
      ),
    );
  }

  
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      width: double.infinity, 
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}