import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiet/app/data/model/alimento.dart';
import 'package:mydiet/app/data/repositories/alimento_repository.dart';
import 'package:mydiet/app/widgets/form_field_wiget.dart';
import 'package:provider/provider.dart';

class AdicionarAlimento extends StatefulWidget {
  const AdicionarAlimento({super.key});

  @override
  State<AdicionarAlimento> createState() => _AdicionarAlimentoState();
}

class _AdicionarAlimentoState extends State<AdicionarAlimento> {
  final _form = GlobalKey<FormState>();
  final _nomeAlimento = TextEditingController();
  final _qntdCalorias = TextEditingController();
  final _qntdProteina = TextEditingController();
  final _qntdCarboidrato = TextEditingController();
  final _qntdGordura = TextEditingController();
  final _unidadeMedida = TextEditingController();
  final _valorCota = TextEditingController();
  bool _mostrarInfosAdicionais = false;

  void criarAlimento() {
    if (_form.currentState!.validate()) {
      final alimentoRepository = context.read<AlimentoRepository>();
      alimentoRepository.saveAlimento(
        Alimento(
          nome: _nomeAlimento.text,
          caloria: _qntdCalorias.text,
          unidadeMedida: _unidadeMedida.text,
          valorCota: _valorCota.text,
          carboidratos: _qntdCarboidrato.text,
          gordura: _qntdGordura.text,
          proteina: _qntdProteina.text,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alimento criado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Adicionar Alimento'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    CampoTexto(
                      controller: _nomeAlimento,
                      label: 'Nome do alimento',
                      icone: FontAwesomeIcons.burger,
                      apenasNumeros: false,
                      erroVazio: "Digite o nome do alimento",
                    ),
                    CampoTexto(
                      controller: _unidadeMedida,
                      label: "Unidade de medida",
                      apenasNumeros: false,
                      erroVazio:
                          "Digite a unidade de medida EX: Colher de sopa",
                    ),
                    CampoTexto(
                      controller: _valorCota,
                      label: "Valor da cota",
                      apenasNumeros: true,
                      erroVazio: "Digite o valor da cota",
                    ),
                    CampoTexto(
                      controller: _qntdCalorias,
                      label: "Qntd de caloria",
                      textoSufixo: "Kcal",
                      apenasNumeros: true,
                      erroVazio: "Digite a qntd de calorias!",
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _mostrarInfosAdicionais = !_mostrarInfosAdicionais;
                        });
                      },
                      child: Text(
                        _mostrarInfosAdicionais
                            ? 'Ocultar informações adicionais'
                            : 'Mostrar informações adicionais',
                      ),
                    ),

                    if (_mostrarInfosAdicionais) ...[
                      CampoTexto(
                        controller: _qntdCarboidrato,
                        label: "Qntd de carboidratos",
                        textoSufixo: "g",
                        apenasNumeros: true,
                      ),
                      CampoTexto(
                        controller: _qntdGordura,
                        label: "Qntd de gordura",
                        textoSufixo: "g",
                        apenasNumeros: true,
                      ),
                      CampoTexto(
                        controller: _qntdProteina,
                        label: "Qntd de proteina",
                        textoSufixo: "g",
                        apenasNumeros: true,
                      ),
                    ],
                  ].expand((w) => [w, const SizedBox(height: 1)]).toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: criarAlimento,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Criar',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomeAlimento.dispose();
    _qntdCalorias.dispose();
    _qntdCarboidrato.dispose();
    _qntdGordura.dispose();
    _qntdProteina.dispose();
    super.dispose();
  }
}
