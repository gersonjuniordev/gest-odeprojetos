import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/atividade_projeto.dart';

class AtividadeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarAtividade({
    required String projetoId,
    required String usuarioId,
    required TipoAtividade tipo,
    required Map<String, dynamic> dados,
  }) async {
    final atividade = AtividadeProjeto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projetoId: projetoId,
      usuarioId: usuarioId,
      tipo: tipo,
      dados: dados,
      criadoEm: DateTime.now(),
    );

    await _firestore
        .collection('projetos')
        .doc(projetoId)
        .collection('atividades')
        .add(atividade.toJson());
  }

  Stream<List<AtividadeProjeto>> streamAtividades(String projetoId) {
    return _firestore
        .collection('projetos')
        .doc(projetoId)
        .collection('atividades')
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AtividadeProjeto.fromJson(doc.data()))
          .toList();
    });
  }

  Future<Map<String, dynamic>> getMetricasProjeto(String projetoId) async {
    final atividades = await _firestore
        .collection('projetos')
        .doc(projetoId)
        .collection('atividades')
        .get();

    final membros = await _firestore.collection('projetos').doc(projetoId).get();
    final membrosCount = (membros.data()?['membrosIds'] as List?)?.length ?? 0;

    return {
      'totalAtividades': atividades.docs.length,
      'totalMembros': membrosCount,
      'atividadesPorTipo': _contarAtividadesPorTipo(atividades.docs),
      'ultimaAtividade': atividades.docs.isNotEmpty
          ? atividades.docs.first.data()['criadoEm']
          : null,
    };
  }

  Map<String, int> _contarAtividadesPorTipo(List<QueryDocumentSnapshot> docs) {
    final contagem = <String, int>{};
    for (var doc in docs) {
      final tipo = doc.data()['tipo'] as String;
      contagem[tipo] = (contagem[tipo] ?? 0) + 1;
    }
    return contagem;
  }
} 