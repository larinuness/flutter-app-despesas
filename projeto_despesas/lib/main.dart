import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'components/chart.dart';
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
  bool _showChart = false;
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: "t1",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t2",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t3",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t4",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t5",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t6",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t7",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t8",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t9",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t10",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t11",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "t12",
    //   title: "Jogo",
    //   value: 50.50,
    //   date: DateTime.now(),
    // ),
  ];

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
    //deixa o app no modo retrato
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final mediaQuery = MediaQuery.of(context);
    bool isLandScape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text(
        'Despesas Pessoais',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: const Icon(Icons.shopping_basket_outlined),
      actions: [
        if (isLandScape)
          IconButton(
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
            icon: Icon(
              _showChart ? Icons.list : Icons.show_chart,
            ),
          ),
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
    //faz com que o tamanho que escolher pra ocupar a tela
    //não conta com o appBar, assim tem 100% da tela pra gerenciar
    //o espaço
    final avaliableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //vem padrão na column esse atributos
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandScape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('Exibir Gráfico'),
            //       Switch(
            //         value: _showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             _showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (_showChart || !isLandScape)
              SizedBox(
                height: avaliableHeight * (isLandScape ? 0.7 : 0.25),
                child: Chart(recentsTransactions: _recentTransactions),
              ),
            SizedBox(
              height: avaliableHeight * 0.75,
              child: TransactionList(
                  transactions: _transactions, onRemove: _removeTransaction),
            )
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
