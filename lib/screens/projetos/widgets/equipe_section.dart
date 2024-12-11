import 'package:flutter/material.dart';
import '../../../services/equipe_service.dart';
import 'buscar_usuario_dialog.dart';
import '../../../models/membro_projeto.dart';
import 'permissoes_dialog.dart';

class EquipeSection extends StatelessWidget {
  final String projetoId;
  final List<String> membrosIds;
  final EquipeService _equipeService = EquipeService();

  EquipeSection({
    super.key,
    required this.projetoId,
    required this.membrosIds,
  });

  Future<void> _adicionarMembro(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => BuscarUsuarioDialog(
        projetoId: projetoId,
        membrosAtuais: membrosIds,
      ),
    );
  }

  Widget _buildMembroTile(Map<String, dynamic> membro) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(membro['nome'][0].toUpperCase()),
      ),
      title: Text(membro['nome']),
      subtitle: Text(membro['email']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => PermissoesDialog(
                projetoId: projetoId,
                membroId: membro['id'],
                permissaoAtual: membro['permissao'],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _equipeService.removerMembro(
              projetoId,
              membro['id'],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Equipe',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () => _adicionarMembro(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _equipeService.streamMembros(projetoId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Erro ao carregar membros');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final membros = snapshot.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: membros.length,
                  itemBuilder: (context, index) {
                    final membro = membros[index];
                    return _buildMembroTile(membro);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 