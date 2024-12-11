import 'package:flutter/material.dart';
import '../../models/projeto.dart';
import '../../services/atividade_service.dart';
import 'widgets/equipe_section.dart';
import 'widgets/historico_atividades.dart';
import 'widgets/chat_projeto.dart';

class ProjetoDetalhesPage extends StatefulWidget {
  final Projeto projeto;

  const ProjetoDetalhesPage({super.key, required this.projeto});

  @override
  State<ProjetoDetalhesPage> createState() => _ProjetoDetalhesPageState();
}

class _ProjetoDetalhesPageState extends State<ProjetoDetalhesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AtividadeService _atividadeService = AtividadeService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildMetricas() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _atividadeService.getMetricasProjeto(widget.projeto.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar métricas'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final metricas = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumo do Projeto',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildMetricaItem(
                        'Total de Atividades',
                        metricas['totalAtividades'].toString(),
                      ),
                      _buildMetricaItem(
                        'Membros da Equipe',
                        metricas['totalMembros'].toString(),
                      ),
                      if (metricas['ultimaAtividade'] != null)
                        _buildMetricaItem(
                          'Última Atividade',
                          metricas['ultimaAtividade'].toString(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Atividades por Tipo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildAtividadesPorTipo(
                Map<String, int>.from(metricas['atividadesPorTipo']),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricaItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAtividadesPorTipo(Map<String, int> atividadesPorTipo) {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: atividadesPorTipo.length,
        itemBuilder: (context, index) {
          final tipo = atividadesPorTipo.keys.elementAt(index);
          final quantidade = atividadesPorTipo[tipo];
          return ListTile(
            title: Text(tipo),
            trailing: Text(
              quantidade.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projeto.nome),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Detalhes'),
            Tab(icon: Icon(Icons.group), text: 'Equipe'),
            Tab(icon: Icon(Icons.history), text: 'Histórico'),
            Tab(icon: Icon(Icons.chat), text: 'Chat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descrição',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(widget.projeto.descricao),
                      ],
                    ),
                  ),
                ),
                _buildMetricas(),
              ],
            ),
          ),
          SingleChildScrollView(
            child: EquipeSection(
              projetoId: widget.projeto.id,
              membrosIds: widget.projeto.membrosIds,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: HistoricoAtividades(projetoId: widget.projeto.id),
            ),
          ),
          ChatProjeto(projetoId: widget.projeto.id),
        ],
      ),
    );
  }
} 