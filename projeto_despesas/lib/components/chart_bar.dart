import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  //label vai ser onde fica os dias da semana
  final String label;
  final double value;
  final double percentage;

  const ChartBar({
    Key? key,
    required this.label,
    required this.value,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //diminui o valor pra tentar fica igual aos outros
        SizedBox(
          height: 17,
          child: FittedBox(
            child: Text(
              value.toStringAsFixed(2).replaceAll('.', ','),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 60,
          width: 10,
          child: Stack(
            //deixa o gráfico subindo de baixa pra cima
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              //um sizedbox fracionado
              FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(label)
      ],
    );
  }
}
