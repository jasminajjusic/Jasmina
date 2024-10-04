import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transactions_page.dart';
import 'transaction_bloc.dart'; 


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BalanceCubit>(
          create: (context) => BalanceCubit(), 
        ),
        BlocProvider<TransactionCubit>(
          create: (context) => TransactionCubit(
            BlocProvider.of<BalanceCubit>(context), 
          )..loadTransactions(), 
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transaction App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TransactionsPage(), 
    );
  }
}
