import 'package:flutter/material.dart';
import '../../../models/atividade_projeto.dart';
import '../../../services/atividade_service.dart';

class HistoricoAtividades extends StatelessWidget {
  final String projetoId;
  final AtividadeService _atividadeService = AtividadeService();

  HistoricoAtividades({
    super.key,
    required this.projetoId,
  });

  String _formatarAtividade(AtividadeProjeto atividade) {
    switch (atividade.tipo) {
      case TipoAtividade.criacaoProjeto:
        return 'Projeto criado';
      case TipoAtividade.atualizacaoProjeto:
        return 'Projeto atualizado: ${atividade.dados['campo']}';
      case TipoAtividade.adicaoMembro:
        return 'Membro adicionado: ${atividade.dados['nomeMembro']}';
      case TipoAtividade.remocaoMembro:
        return 'Membro removido: ${atividade.dados['nomeMembro']}';
      case TipoAtividade.alteracaoPermissao:
        return 'Permissão alterada: ${atividade.dados['nomeMembro']} - ${atividade.dados['novaPermissao']}';
      case TipoAtividade.mensagemChat:
        return 'Nova mensagem no chat';
      default:
        return 'Atividade desconhecida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AtividadeProjeto>>(
      stream: _atividadeService.streamAtividades(projetoId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao carregar atividades');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final atividades = snapshot.data ?? [];

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: atividades.length,
          itemBuilder: (context, index) {
            final atividade = atividades[index];
            return ListTile(
              leading: Icon(_getIconeAtividade(atividade.tipo)),
              title: Text(_formatarAtividade(atividade)),
              subtitle: Text(
                'Em ${atividade.criadoEm.toString().split('.')[0]}',
              ),
            );
          },
        );
      },
    );
  }

  IconData _getIconeAtividade(TipoAtividade tipo) {
    switch (tipo) {
      case TipoAtividade.criacaoProjeto:
        return Icons.create_new_folder;
      case TipoAtividade.atualizacaoProjeto:
        return Icons.edit;
      case TipoAtividade.adicaoMembro:
        return Icons.person_add;
      case TipoAtividade.remocaoMembro:
        return Icons.person_remove;
      case TipoAtividade.alteracaoPermissao:
        return Icons.admin_panel_settings;
      case TipoAtividade.mensagemChat:
        return Icons.chat;
      default:
        return Icons.info;
    }
  }
} 