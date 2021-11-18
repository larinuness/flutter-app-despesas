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
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            //diminui o valor pra tentar fica igual aos outros
            SizedBox(
              height: constraints.maxHeight * 0.15,
              //tenta deixa o texto sempre do mesmo tamanho, mesmo o valor nele
              //sendo maior
              child: FittedBox(
                child: Text(
                  value.toStringAsFixed(2).replaceAll('.', ','),
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                //deixa o gráfico subindo de baixa pra cima
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: const Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(5),
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
            SizedBox(height: constraints.maxHeight * 0.05),
            SizedBox(
              child: FittedBox(
                child: Text(label),
              ),
              height: constraints.maxHeight * 0.15,
            )
          ],
        );
      },
    );
  }
}
