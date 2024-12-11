import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/equipe_service.dart';

class BuscarUsuarioDialog extends StatefulWidget {
  final String projetoId;
  final List<String> membrosAtuais;

  const BuscarUsuarioDialog({
    super.key,
    required this.projetoId,
    required this.membrosAtuais,
  });

  @override
  State<BuscarUsuarioDialog> createState() => _BuscarUsuarioDialogState();
}

class _BuscarUsuarioDialogState extends State<BuscarUsuarioDialog> {
  final _searchController = TextEditingController();
  final _equipeService = EquipeService();
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar usuário',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _searchTerm = value),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .where('nome', isGreaterThanOrEqualTo: _searchTerm)
                  .where('nome', isLessThan: _searchTerm + 'z')
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Erro ao buscar usuários');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final usuarios = snapshot.data?.docs ?? [];
                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];
                      final usuarioData = usuario.data() as Map<String, dynamic>;
                      final jaMembro = widget.membrosAtuais.contains(usuario.id);

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(usuarioData['nome'][0].toUpperCase()),
                        ),
                        title: Text(usuarioData['nome']),
                        subtitle: Text(usuarioData['email']),
                        trailing: jaMembro
                            ? const Icon(Icons.check_circle)
                            : IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  await _equipeService.adicionarMembro(
                                    widget.projetoId,
                                    usuario.id,
                                  );
                                  if (mounted) Navigator.pop(context);
                                },
                              ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 