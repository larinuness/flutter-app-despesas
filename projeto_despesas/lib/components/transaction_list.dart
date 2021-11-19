import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;
  const TransactionList(
      {Key? key, required this.transactions, required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text(
                    'Nenhuma Transação Cadastrada!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: constraints.maxHeight * 0.2,
                    child: Image.asset(
                      'assets/images/sademoji.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            //quantidade de itens
            itemCount: transactions.length,
            // ctx = context
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text(
                          'R\$${tr.value.toString().replaceAll('.', ',')}',
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    tr.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y').format(tr.date),
                  ),
                  trailing: IconButton(
                    onPressed: () => onRemove(tr.id),
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
  }
}
