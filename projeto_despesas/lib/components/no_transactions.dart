import 'package:flutter/material.dart';

class NoTransactions extends StatelessWidget {
  const NoTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Você não possui Transações',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 20,
        ),
        Center(
          child:
              Image.asset('assets/images/sademoji.png', height: 90, width: 90),
        ),
      ],
    );
  }
}
