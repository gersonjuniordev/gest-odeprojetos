import 'package:flutter/material.dart';
import '../../../models/membro_projeto.dart';
import '../../../services/equipe_service.dart';

class PermissoesDialog extends StatefulWidget {
  final String projetoId;
  final String membroId;
  final NivelPermissao permissaoAtual;

  const PermissoesDialog({
    super.key,
    required this.projetoId,
    required this.membroId,
    required this.permissaoAtual,
  });

  @override
  State<PermissoesDialog> createState() => _PermissoesDialogState();
}

class _PermissoesDialogState extends State<PermissoesDialog> {
  late NivelPermissao _permissaoSelecionada;
  final _equipeService = EquipeService();

  @override
  void initState() {
    super.initState();
    _permissaoSelecionada = widget.permissaoAtual;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alterar Permissões'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: NivelPermissao.values.map((nivel) {
          return RadioListTile<NivelPermissao>(
            title: Text(nivel.toString().split('.').last),
            value: nivel,
            groupValue: _permissaoSelecionada,
            onChanged: (value) {
              if (value != null) {
                setState(() => _permissaoSelecionada = value);
              }
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _equipeService.atualizarPermissao(
              widget.projetoId,
              widget.membroId,
              _permissaoSelecionada,
            );
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
} 