import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiet/app/pages/adicionar_alimento_page.dart';
import 'package:mydiet/app/pages/adicionar_refeicao_page.dart';
import 'package:mydiet/app/pages/mostrar_refeicoes_page.dart';
import 'package:mydiet/app/data/controllers/refeicao_controller.dart';
import 'package:mydiet/app/data/model/refeicao.dart';
import 'package:provider/provider.dart';
import 'configuracoes_page.dart';
import 'userPages/perfil_page.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _paginaAtual = 0;

  void adicionarAlimento() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdicionarAlimento()),
    );
  }

  void adicionarRefeicao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdicionarRefeicao()),
    );
  }

  void irParaRefeicao(String periodo) {
    setState(() {
      _paginaAtual = 1;
    });
  }

  Widget _buildHomePage() {
    final ordemPeriodos = [
      'Café da Manhã',
      'Almoço',
      'Lanche da Tarde',
      'Jantar',
    ];

    final iconePorPeriodo = {
      'Café da Manhã': Icons.free_breakfast_outlined,
      'Almoço': Icons.lunch_dining_outlined,
      'Lanche da Tarde': Icons.bakery_dining_outlined,
      'Jantar': Icons.dinner_dining_outlined,
    };

    return Consumer<RefeicaoRepository>(
      builder: (context, refeicaoRepo, child) {
        final refeicoesDoDia = refeicaoRepo.refeicoesDoDia;

        final Map<String, List<Refeicao>> agrupadas = {};
        for (final refeicao in refeicoesDoDia) {
          agrupadas.putIfAbsent(refeicao.periodoRefeicao, () => []);
          agrupadas[refeicao.periodoRefeicao]!.add(refeicao);
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            Text(
              'Refeições de Hoje',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (refeicoesDoDia.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.no_food_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nenhuma refeição cadastrada hoje.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...ordemPeriodos.map((periodo) {
                final refeicoes = agrupadas[periodo];
                if (refeicoes == null || refeicoes.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        periodo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...refeicoes.map((refeicao) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => irParaRefeicao(periodo),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  iconePorPeriodo[periodo] ??
                                      Icons.restaurant_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        refeicao.nomeRefeicao,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _paginas = [
      _buildHomePage(),
      const MostrarRefeicao(),
      const ConfiguracoesPage(),
      const PerfilPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyDiet'),
      ),
      body: _paginas[_paginaAtual],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => setState(() => _paginaAtual = 0),
                icon: const Icon(Icons.home),
              ),
              IconButton(
                onPressed: () => setState(() => _paginaAtual = 1),
                icon: const Icon(Icons.food_bank_outlined),
              ),
              const SizedBox(width: 48),
              IconButton(
                onPressed: () => setState(() => _paginaAtual = 2),
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () => setState(() => _paginaAtual = 3),
                icon: const Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: const Icon(FontAwesomeIcons.appleWhole),
            label: "Adicionar Alimento",
            onTap: adicionarAlimento,
          ),
          SpeedDialChild(
            child: const Icon(Icons.flatware_outlined),
            label: "Criar Refeição",
            onTap: adicionarRefeicao,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
