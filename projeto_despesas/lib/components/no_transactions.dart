import 'package:flutter/material.dart';

class NoTransactions extends StatelessWidget {
  const NoTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          SizedBox(height: constraints.maxHeight * 0.1),
          SizedBox(
            height: constraints.maxHeight * 0.2,
            child: const Text('Você não possui Transações',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Center(
            child: Image.asset('assets/images/sademoji.png',
                height: constraints.maxHeight * 0.3,
                width: constraints.maxWidth * 0.3),
          ),
        ],
      );
    });
  }
}
