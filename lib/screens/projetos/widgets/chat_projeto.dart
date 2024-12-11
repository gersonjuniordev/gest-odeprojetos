import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/atividade_service.dart';

class ChatProjeto extends StatefulWidget {
  final String projetoId;

  const ChatProjeto({
    super.key,
    required this.projetoId,
  });

  @override
  State<ChatProjeto> createState() => _ChatProjetoState();
}

class _ChatProjetoState extends State<ChatProjeto> {
  final _mensagemController = TextEditingController();
  final _atividadeService = AtividadeService();
  final _firestore = FirebaseFirestore.instance;

  Future<void> _enviarMensagem() async {
    if (_mensagemController.text.trim().isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('projetos')
          .doc(widget.projetoId)
          .collection('chat')
          .add({
        'texto': _mensagemController.text,
        'usuarioId': user.uid,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      await _atividadeService.registrarAtividade(
        projetoId: widget.projetoId,
        usuarioId: user.uid,
        tipo: TipoAtividade.mensagemChat,
        dados: {'mensagem': _mensagemController.text},
      );

      _mensagemController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar mensagem')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('projetos')
                .doc(widget.projetoId)
                .collection('chat')
                .orderBy('criadoEm', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar mensagens'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final mensagens = snapshot.data?.docs ?? [];

              return ListView.builder(
                reverse: true,
                itemCount: mensagens.length,
                itemBuilder: (context, index) {
                  final mensagem = mensagens[index].data() as Map<String, dynamic>;
                  final isUsuarioAtual =
                      mensagem['usuarioId'] == FirebaseAuth.instance.currentUser?.uid;

                  return Align(
                    alignment: isUsuarioAtual
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUsuarioAtual
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        mensagem['texto'] as String,
                        style: TextStyle(
                          color: isUsuarioAtual ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _mensagemController,
                  decoration: const InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _enviarMensagem,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 