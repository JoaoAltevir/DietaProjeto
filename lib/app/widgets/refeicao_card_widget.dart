import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiet/app/data/model/alimento.dart';
import 'package:mydiet/app/data/model/refeicao.dart';
import 'package:mydiet/app/data/repositories/refeicao_repository.dart';
import 'package:mydiet/app/widgets/form_field_wiget.dart';
import 'package:provider/provider.dart';

class RefeicaoCard extends StatefulWidget {
  final Refeicao refeicao;
  const RefeicaoCard({super.key, required this.refeicao});

  @override
  State<RefeicaoCard> createState() => _RefeicaoCardState();
}

class _RefeicaoCardState extends State<RefeicaoCard> {
  final _formAlimento = GlobalKey<FormState>();
  final _nomeAlimento = TextEditingController();
  final _qntdCalorias = TextEditingController();
  final _qntdProteina = TextEditingController();
  final _qntdCarboidrato = TextEditingController();
  final _qntdGordura = TextEditingController();
  final _unidadeMedida = TextEditingController();
  final _valorCota = TextEditingController();

  void salvarMudancas(Alimento alimento) {
    if (_formAlimento.currentState!.validate()) {
      alimento.nome = _nomeAlimento.text;
      alimento.unidadeMedida = _unidadeMedida.text;
      alimento.valorCota = _valorCota.text;
      alimento.caloria = _qntdCalorias.text;
      alimento.carboidratos = _qntdCarboidrato.text;
      alimento.gordura = _qntdGordura.text;
      alimento.proteina = _qntdProteina.text;

      Provider.of<RefeicaoRepository>(
        context,
        listen: false,
      ).editarAlimento();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alimento ${alimento.nome} foi alterado com sucesso!'),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
      Navigator.pop(context);
    }
  }

  void deletarAlimento(Alimento alimento) {
    Provider.of<RefeicaoRepository>(
      context,
      listen: false,
    ).removerAlimento(
      widget.refeicao,
      alimento,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alimento ${alimento.nome} foi deletado!'),
        backgroundColor: Colors.blueGrey,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final totalCalorias = widget.refeicao.alimentoListaRefeicao.fold<double>(
      0,
      (total, alimento) {
        final cal = double.tryParse(alimento.caloria) ?? 0;
        return total + cal;
      },
    );
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Text(
          widget.refeicao.nomeRefeicao,
          style: TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          "Total de calorias: ${totalCalorias.toStringAsFixed(0)} kcal\n Horário: ${widget.refeicao.dataRefeicao.hour}h:${widget.refeicao.dataRefeicao.minute}min ",
        ),

        children: widget.refeicao.alimentoListaRefeicao.map((alimento) {
          return ListTile(
            title: Text(
              alimento.nome,
            ),
            subtitle: Text(
              "Unidade de medida: ${alimento.unidadeMedida}\n"
              "Valor da Cota:${alimento.valorCota}\n"
              "Calorias: ${alimento.caloria} kcal\n ",
            ),
            onTap: () {
              _nomeAlimento.text = alimento.nome;
              _unidadeMedida.text = alimento.unidadeMedida;
              _valorCota.text = alimento.valorCota;
              _qntdCalorias.text = alimento.caloria;
              _qntdCarboidrato.text = alimento.carboidratos;
              _qntdGordura.text = alimento.gordura;
              _qntdProteina.text = alimento.proteina;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Form(
                        key: _formAlimento,
                        child: Column(
                          children: [
                            Text(
                              "Editar ${alimento.nome}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 16),

                            CampoTexto(
                              controller: _nomeAlimento,
                              label: 'Nome do alimento',
                              icone: FontAwesomeIcons.burger,
                              erroVazio: "Digite o nome do alimento",
                              apenasNumeros: false,
                            ),

                            CampoTexto(
                              controller: _unidadeMedida,
                              label: "Unidade de medida",
                              erroVazio: "Digite a unidade de medida",
                              apenasNumeros: false,
                            ),

                            CampoTexto(
                              controller: _valorCota,
                              label: "Valor da cota",
                              apenasNumeros: true,
                            ),

                            CampoTexto(
                              controller: _qntdCalorias,
                              label: "Calorias",
                              textoSufixo: "Kcal",
                              apenasNumeros: true,
                            ),

                            CampoTexto(
                              controller: _qntdCarboidrato,
                              label: "Carboidratos",
                              textoSufixo: "g",
                              apenasNumeros: true,
                            ),

                            CampoTexto(
                              controller: _qntdGordura,
                              label: "Gordura",
                              textoSufixo: "g",
                              apenasNumeros: true,
                            ),

                            CampoTexto(
                              controller: _qntdProteina,
                              label: "Proteína",
                              textoSufixo: "g",
                              apenasNumeros: true,
                            ),

                            SizedBox(height: 20),

                            // BOTÕES
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      deletarAlimento(alimento);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: Text("Deletar"),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      salvarMudancas(alimento);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: Text("Salvar"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
