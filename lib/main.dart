import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transactions_page.dart';
import 'transaction_bloc.dart'; // Importuj TransactionCubit i TransactionState
import 'TopUpPage.dart'; // Importuj TopUpPage

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BalanceCubit>(
          create: (context) => BalanceCubit(), // Inicijalizuj BalanceCubit
        ),
        BlocProvider<TransactionCubit>(
          create: (context) => TransactionCubit()..loadTransactions(), // Učitaj transakcije odmah
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transaction App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TransactionsPage(), // Postavi početnu stranicu
    );
  }
}
