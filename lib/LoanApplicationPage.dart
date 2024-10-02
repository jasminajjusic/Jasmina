import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loan_application_cubit.dart';

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  _LoanApplicationPageState createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController expensesController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController loanTermController = TextEditingController();
  final TextEditingController moneyInAccountController = TextEditingController(); 
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoanApplicationCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
          title: const Center(
            child: Text(
              'Loan Application',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<LoanApplicationCubit, LoanApplicationState>(
          listener: (context, state) {
            if (state is LoanApproved) {
              _showDialog(context, "Yeeeyyy !! Congrats. Your application has been approved. Don't tell your friends you have money!");
            } else if (state is LoanDeclined) {
              _showDialog(context, "Ooopsss. Your application has been declined. It's not your fault, it's a financial crisis.");
            } else if (state is LoanAlreadyApplied) {
              _showDialog(context, "Ooopsss, you applied before. Wait for notification from us.");
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Terms and Conditions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam elementum enim nec luctus."
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam elementum enim nec luctus."
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam elementum enim nec luctus."
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam elementum enim nec luctus.",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          termsAccepted = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'I accept the Terms and Conditions',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                const Text(
                  "ABOUT YOU",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _buildInputField(salaryController, 'Monthly Salary'),
                const SizedBox(height: 10),
                _buildInputField(expensesController, 'Monthly Expenses'),
                const SizedBox(height: 10),
                _buildInputField(moneyInAccountController, 'Money in Account'), 
                const Divider(height: 30),
                const Text(
                  "LOAN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _buildInputField(loanAmountController, 'Loan Amount'),
                const SizedBox(height: 10),
                _buildInputField(loanTermController, 'Term (months)'),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(196, 20, 166, 1),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide.none, 
                        ),
                      ),
                      onPressed: () {
                        if (termsAccepted) {
                          final salary = double.tryParse(salaryController.text) ?? 0;
                          final expenses = double.tryParse(expensesController.text) ?? 0;
                          final loanAmount = double.tryParse(loanAmountController.text) ?? 0;
                          final loanTerm = int.tryParse(loanTermController.text) ?? 0;
                          final moneyInAccount = double.tryParse(moneyInAccountController.text) ?? 0; 

                          if (moneyInAccount > 1000) {
                            context.read<LoanApplicationCubit>().applyForLoan(
                              monthlySalary: salary,
                              monthlyExpenses: expenses,
                              loanAmount: loanAmount,
                              loanTerm: loanTerm,
                              moneyInAccount: moneyInAccount, 
                            );
                          } else {
                            _showDialog(context, "You need to have more than \$1000 in your account.");
                          }
                        } else {
                          _showDialog(context, "Please accept the Terms & Conditions.");
                        }
                      },
                      child: const Text(
                        'Apply for loan',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String labelText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none, 
          fillColor: Colors.white,
          filled: true,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Loan Decision"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
