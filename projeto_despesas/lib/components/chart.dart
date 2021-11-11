import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

//o gráfico sempre vai pegar as transações final do mes
class Chart extends StatelessWidget {
  final List<Transaction> recentsTransactions;

  const Chart({Key? key, required this.recentsTransactions}) : super(key: key);
  //tipo Object pq cada dia da semana vai ser um Object
  List<Map<String, Object>> get groupedTransactions {
    //gera com 7 itens, no caso 7 dias da semana
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (var i = 0; i < recentsTransactions.length; i++) {
        //vai comparar se é o mesmo dia
        bool sameDay = recentsTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentsTransactions[i].date.month == weekDay.month;
        bool sameYear = recentsTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentsTransactions[i].value;
        }
      }

      return {
        //vai da a sigla do dia da semana
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20.0),
      child: Row(
        children: [],
      ),
    );
  }
}
