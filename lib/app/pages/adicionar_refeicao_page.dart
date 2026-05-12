import 'package:flutter/material.dart';
import 'package:mydiet/app/data/model/alimento.dart';
import 'package:mydiet/app/data/model/refeicao.dart';
import 'package:mydiet/app/data/repositories/alimento_repository.dart';
import 'package:mydiet/app/data/repositories/refeicao_repository.dart';
import 'package:mydiet/app/widgets/alimento_card_widget.dart';
import 'package:provider/provider.dart';

class AdicionarRefeicao extends StatefulWidget {
  const AdicionarRefeicao({super.key});

  @override
  State<AdicionarRefeicao> createState() => _AdicionarRefeicaoState();
}

class _AdicionarRefeicaoState extends State<AdicionarRefeicao> {
  late AlimentoRepository alimentosTabela;
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String? valorSelecionado;
  final _formRef = GlobalKey<FormState>();
  List<Alimento> selecionados = [];
  final _nomeRefeicao = TextEditingController();
  String? _erroDataHora;

  void criarRefeicao() {
    if (_dataSelecionada == null || _horaSelecionada == null) {
      setState(() {
        _erroDataHora = "Selecione data e hora";
      });
      return;
    }

    if (_formRef.currentState!.validate() && selecionados.isNotEmpty) {
      final dataFinal = DateTime(
        _dataSelecionada!.year,
        _dataSelecionada!.month,
        _dataSelecionada!.day,
        _horaSelecionada!.hour,
        _horaSelecionada!.minute,
      );
      final refeicaoRepository = context.read<RefeicaoRepository>();
      refeicaoRepository.saveRefeicao(
        Refeicao(
          nomeRefeicao: _nomeRefeicao.text,
          dataRefeicao: dataFinal,
          alimentoListaRefeicao: selecionados,
          periodoRefeicao: valorSelecionado.toString(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Refeicao criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      if (selecionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Selecione pelo menos um alimento",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora != null) {
      setState(() {
        _horaSelecionada = hora;
      });
    }
  }

  @override
  void dispose() {
    _nomeRefeicao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    alimentosTabela = Provider.of<AlimentoRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Refeicao'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formRef,
                    child: Padding(
                      padding: const EdgeInsets.all(21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nomeRefeicao,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              labelText: "Digite o nome da refeição",
                              prefixIcon: Icon(Icons.fastfood),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite um nome para a refeição!";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _selecionarData,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "Data",
                                      prefixIcon: Icon(
                                        Icons.date_range_rounded,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      errorText: _erroDataHora,
                                    ),
                                    child: Text(
                                      _dataSelecionada == null
                                          ? "Selecione dia"
                                          : "${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}",
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              // HORA
                              Expanded(
                                child: InkWell(
                                  onTap: _selecionarHora,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "Hora",
                                      prefixIcon: Icon(Icons.timer_sharp),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      _horaSelecionada == null
                                          ? "Selecione hora"
                                          : "${_horaSelecionada!.hour.toString().padLeft(2, '0')}:"
                                                "${_horaSelecionada!.minute.toString().padLeft(2, '0')}",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          DropdownButtonFormField<String>(
                            initialValue: valorSelecionado,
                            decoration: InputDecoration(
                              labelText: "Período da refeição",
                              prefixIcon: Icon(Icons.restaurant_menu),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            hint: Text("Selecione o período da refeição"),
                            items: [
                              DropdownMenuItem(
                                value: "Café da Manhã",
                                child: Text("Café da Manhã"),
                              ),
                              DropdownMenuItem(
                                value: "Almoço",
                                child: Text("Almoço"),
                              ),
                              DropdownMenuItem(
                                value: "Lanche da Tarde",
                                child: Text("Lanche da Tarde"),
                              ),
                              DropdownMenuItem(
                                value: "Jantar",
                                child: Text("Jantar"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                valorSelecionado = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Selecione um período";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ALIMENTOS",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),
                    Expanded(
                      child: Consumer<AlimentoRepository>(
                        builder: (context, alimentosTabela, child) {
                          return alimentosTabela.listaAlimentos.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum alimento encontrado.\nCrie antes de adicionar uma refeição!',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      alimentosTabela.listaAlimentos.length,
                                  itemBuilder: (_, index) {
                                    final alimento =
                                        alimentosTabela.listaAlimentos[index];

                                    final selecionado = selecionados.contains(
                                      alimento,
                                    );

                                    return AlimentosCard(
                                      alimento: alimento,
                                      key: ValueKey(alimento.nome),
                                      selecionado: selecionado,
                                      onTap: () {
                                        setState(() {
                                          if (selecionado) {
                                            selecionados.remove(alimento);
                                          } else {
                                            selecionados.add(alimento);
                                          }
                                        });
                                      },
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: criarRefeicao,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
