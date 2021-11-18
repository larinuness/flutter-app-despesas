import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_despesas/components/chart.dart';
import 'components/transaction_form.dart';

import '../models/transaction.dart';

import 'components/transaction_list.dart';

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
          // ignore: deprecated_member_use
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
  final List<Transaction> _transactions = [];

  //filter
  //vai checar se as transações entra dentro dos 7 dias
  //se for fora do 7 dias vai retornar false
  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      //se a data for depois de uma data subtraida 7 dias atrás(dataRecente)
      // é true
      //se for antes, é false
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    //aparecer um modal no rodapé
    showModalBottomSheet(
        //o context é a MyHomePage
        context: context,
        builder: (_) {
          return SizedBox(
            height: 350,
            child: TransactionForm(onSubmit: _addTransaction),
          );
        });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      //pega um valor double aleatório e converte em String
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
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

  //function que vai excluir uma transação
  _removeTransaction(String id) {
    //tá no setState porque vai deletar na hora
    setState(() {
      //tr = transaction
      _transactions.removeWhere((tr) => tr.id == id);
    });
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
        actions: [
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //vem padrão na column esse atributos
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(recentsTransactions: _recentTransactions),
            TransactionList(
                transactions: _transactions, onRemove: _removeTransaction)
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
