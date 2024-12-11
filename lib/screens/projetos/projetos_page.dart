import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/projeto.dart';

class ProjetosPage extends StatelessWidget {
  const ProjetosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projetos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NovoProjeto()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('projetos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar projetos'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final projetos = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Projeto.fromJson({...data, 'id': doc.id});
          }).toList();

          return ListView.builder(
            itemCount: projetos.length,
            itemBuilder: (context, index) {
              final projeto = projetos[index];
              return ListTile(
                title: Text(projeto.nome),
                subtitle: Text(projeto.descricao),
                trailing: Chip(label: Text(projeto.status)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjetoDetalhesPage(projeto: projeto),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 