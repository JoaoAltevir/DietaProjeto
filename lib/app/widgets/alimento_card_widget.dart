import 'package:flutter/material.dart';
import 'package:mydiet/app/data/model/alimento.dart';

class AlimentosCard extends StatelessWidget {
  final Alimento alimento;
  final bool selecionado;
  final VoidCallback onTap;

  const AlimentosCard({
    super.key,
    required this.alimento,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        //QUANDO DER TEMPO CONSERTAR O COLOR, ELE TA BUGANDO E APARECENDO ONDE NÃO DEVIA
        //color: selecionado ? Colors.greenAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: ListTile(
          leading: selecionado
              ? const CircleAvatar(child: Icon(Icons.check))
              : const Icon(Icons.square_outlined),
          title: Text(
            alimento.nome,
            style: const TextStyle(fontSize: 25),
          ),
          subtitle: Text(
            "Unidade de medida: ${alimento.unidadeMedida}\n"
            "Valor da cota: ${alimento.valorCota}\n"
            "Gordura: ${alimento.gordura}g\n"
            "Caloria: ${alimento.caloria}g\n"
            "Carboidratos: ${alimento.carboidratos}g\n"
            "Proteína: ${alimento.proteina}g",
          ),
        ),
      ),
    );
  }
}
