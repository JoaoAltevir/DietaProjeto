import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:mydiet/app/data/model/refeicao.dart';
import 'package:mydiet/app/data/controllers/refeicao_controller.dart';
import 'package:mydiet/app/widgets/refeicao_card_widget.dart';
import 'package:provider/provider.dart';

class MostrarRefeicao extends StatefulWidget {
  const MostrarRefeicao({super.key});

  @override
  State<MostrarRefeicao> createState() => _MostrarRefeicaoState();
}

class _MostrarRefeicaoState extends State<MostrarRefeicao> {
  late CalendarWeekController _controller;
  late RefeicaoRepository refeicaoTabela;
  final List<String> ordemPeriodos = [
    'Café da Manhã',
    'Almoço',
    'Lanche da Tarde',
    'Jantar',
  ];
  @override
  void initState() {
    super.initState();
    _controller = CalendarWeekController();
  }

  List<Widget> _buildRefeicoesAgrupadas(
    RefeicaoRepository refeicaoTabela,
  ) {
    final Map<String, List<Refeicao>> agrupadas = {};

    final listaFiltrada = refeicaoTabela.refeicoesDoDia;

    for (final refeicao in listaFiltrada) {
      agrupadas.putIfAbsent(refeicao.periodoRefeicao, () => []);
      agrupadas[refeicao.periodoRefeicao]!.add(refeicao);
    }

    return ordemPeriodos.map((periodo) {
      final refeicoes = agrupadas[periodo];

      if (refeicoes == null || refeicoes.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              periodo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...refeicoes.map((refeicao) {
            return RefeicaoCard(refeicao: refeicao);
          }),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: CalendarWeek(
            controller: _controller,
            showMonth: true,
            minDate: DateTime(2020),
            maxDate: DateTime(2100),
            onDatePressed: (date) {
              context.read<RefeicaoRepository>().setDataSelecionada(date);
            },
          ),
        ),

        Expanded(
          child: Consumer<RefeicaoRepository>(
            builder: (context, refeicaoTabela, child) {
              return refeicaoTabela.refeicoesDoDia.isEmpty
                  ? const Center(
                      child: Text('Nenhuma Refeicao encontrada.'),
                    )
                  : ListView(
                      children: _buildRefeicoesAgrupadas(refeicaoTabela),
                    );
            },
          ),
        ),
      ],
    );
  }
}
