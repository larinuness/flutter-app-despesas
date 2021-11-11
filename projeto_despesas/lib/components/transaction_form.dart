import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSubmit;

  const TransactionForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();

  _submitForm() {
    final title = _titleController.text;
    //senão conseguir pegar o valor do controller
    //o valor padrão vai ser 0.0
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      //só sai da função
      //não faz nada
      return;
    }
    //passa os valores do title e value por paramêtro pro atributo do tipo função
    widget.onSubmit(title, value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Titulo',
              ),
              keyboardType: TextInputType.text,
            ),
            TextField(
                // inputFormatters: [maskFormatter],
                controller: _valueController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                ),
                //withOptions porque se for no Ios, vai deixar separar por casas decimais
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true)),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Nova Transação'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
