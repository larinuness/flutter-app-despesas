import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_despesas/components/chart_bar.dart';
import '../models/transaction.dart';

//o gráfico sempre vai pegar as transações final do mes
class Chart extends StatelessWidget {
  final List<Transaction> recentsTransactions;

  const Chart({Key? key, required this.recentsTransactions}) : super(key: key);
  //tipo Object pq cada dia da semana vai ser um Object
  List<Map<String, dynamic>> get groupedTransactions {
    //gera com 7 itens, no caso 7 dias da semana
    //cada index é um dia de semana
    return List.generate(7, (index) {
      //index que está menos o dia de hoje
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (var i = 0; i < recentsTransactions.length; i++) {
        //vai comparar se é o mesmo dia/mes/ano
        //e soma o valor total do dia
        bool sameDay = recentsTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentsTransactions[i].date.month == weekDay.month;
        bool sameYear = recentsTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentsTransactions[i].value;
        }
      }

      return {
        //vai retorna a sigla do dia da semana em inglês
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
      //reversed muda a ordem da lista, o dia atual fica na direita
    }).reversed.toList();
  }

  double get _weekTotalValue {
    //fold é como um reduce, tem o acumulador e o elemento atual
    //faz uma operação sobre esses parametros, o retorno é o acumulador
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + tr['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              flex: 23,
              child: ChartBar(
                label: tr['day'],
                value: tr['value'],
                percentage: _weekTotalValue == 0
                    ? 0
                    : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
