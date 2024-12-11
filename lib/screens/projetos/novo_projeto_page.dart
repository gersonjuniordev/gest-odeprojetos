import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/projeto.dart';

class NovoProjeto extends StatefulWidget {
  const NovoProjeto({super.key});

  @override
  State<NovoProjeto> createState() => _NovoProjetoState();
}

class _NovoProjetoState extends State<NovoProjeto> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _dataInicio;
  bool _salvando = false;

  Future<void> _salvarProjeto() async {
    if (_formKey.currentState!.validate() && _dataInicio != null) {
      setState(() => _salvando = true);
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) return;

        final novoProjeto = {
          'nome': _nomeController.text,
          'descricao': _descricaoController.text,
          'dataInicio': _dataInicio!.toIso8601String(),
          'membrosIds': [userId], // Criador como primeiro membro
          'status': 'Em Andamento',
          'criadoEm': FieldValue.serverTimestamp(),
          'criadoPor': userId,
        };

        await FirebaseFirestore.instance
            .collection('projetos')
            .add(novoProjeto);

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar projeto')),
        );
      } finally {
        if (mounted) setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Projeto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Projeto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Nome obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Descrição obrigatória' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Data de Início'),
                subtitle: Text(_dataInicio?.toString().split(' ')[0] ??
                    'Selecione uma data'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final data = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (data != null) {
                    setState(() => _dataInicio = data);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvando ? null : _salvarProjeto,
                child: _salvando
                    ? const CircularProgressIndicator()
                    : const Text('Criar Projeto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 