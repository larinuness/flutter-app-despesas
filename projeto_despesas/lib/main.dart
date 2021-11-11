import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_despesas/components/no_transactions.dart';
import 'components/transaction_form.dart';

import '../models/transaction.dart';
import './components/transaction_form.dart';
import './components/transaction_list.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          //deixa a cor do floatingActionButton mais escuro
          accentColor: Colors.deepPurple[900],
          textTheme: GoogleFonts.quicksandTextTheme()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: '1',
        title: 'Skin do Jhin',
        value: 50,
        date: DateTime.now().subtract(Duration(days: 2))),
  ];

  _openTransactionFormModal(BuildContext context) {
    //aparecer um modal no rodapé
    showModalBottomSheet(
        //o context é a MyHomePage
        context: context,
        builder: (_) {
          return TransactionForm(onSubmit: _addTransaction);
        });
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      //pega um valor double aleatório e converte em String
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );
    //vai add uma transação nova na lista de transações
    //atualizada a lista com uma transactio nova
    setState(() {
      _transactions.add(newTransaction);
    });
    //fecha o modal quando add uma nova transação
    // Navigator.pop(context);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Despesas Pessoais',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.shopping_basket_outlined),
      ),
      body: SingleChildScrollView(
        child: Column(
          //vem padrão na column esse atributos
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Card(
                child: Text('Gráficos'),
                elevation: 5,
              ),
            ),
            TransactionList(transactions: _transactions)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      //deixa o botão no rodapé centralizado
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
