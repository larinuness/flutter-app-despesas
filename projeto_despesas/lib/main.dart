import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/transaction.dart';
import 'components/chart.dart';
import 'components/transaction_form.dart';
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

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    //deixa o app no modo retrato
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final mediaQuery = MediaQuery.of(context);
    bool isLandScape = mediaQuery.orientation == Orientation.landscape;
    //mostra o tipo icone de cada sistema
    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;
    final actions = <Widget>[
      if (isLandScape)
        _getIconButton(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = AppBar(
      title: const Text('Despesas Pessoais'),
      actions: actions,
    );
    //faz com que o tamanho que escolher pra ocupar a tela
    //não conta com o appBar, assim tem 100% da tela pra gerenciar
    //o espaço
    final avaliableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //vem padrão na column esse atributos
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandscape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Text('Exibir Gráfico'),
            //Switch.adaptive vai mostrar de acordo com o tipo de SO     
            //       Switch.adaptive(
            //activeColor é a cor quando estiver ativo o switch  
            //         activeColor: Theme.of(context).accentColor,
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
                height: avaliableHeight * (isLandScape ? 0.8 : 0.3),
                child: Chart(recentsTransactions: _recentTransactions),
              ),
            SizedBox(
              height: avaliableHeight * (isLandScape ? 1 : 0.7),
              child: TransactionList(
                  transactions: _transactions, onRemove: _removeTransaction),
            )
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            //se for IOS não vai ter o floatingActionButton
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            //deixa o botão no rodapé centralizado
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
