import 'package:cloud_firestore/cloud_firestore.dart';
import 'notificacao_service.dart';
import 'membro_projeto.dart';

class EquipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificacaoService _notificacaoService = NotificacaoService();

  Future<List<Map<String, dynamic>>> buscarMembros(List<String> membrosIds) async {
    final membros = await Future.wait(
      membrosIds.map((id) => _firestore.collection('usuarios').doc(id).get()),
    );

    return membros
        .where((doc) => doc.exists)
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<void> adicionarMembro(
    String projetoId,
    String membroId, {
    NivelPermissao permissao = NivelPermissao.visualizador,
  }) async {
    final membroProjeto = MembroProjeto(
      userId: membroId,
      projetoId: projetoId,
      permissao: permissao,
      adicionadoEm: DateTime.now(),
    );

    await _firestore.collection('membros_projeto').add(membroProjeto.toJson());
    await _firestore.collection('projetos').doc(projetoId).update({
      'membrosIds': FieldValue.arrayUnion([membroId]),
    });

    final projeto = await _firestore.collection('projetos').doc(projetoId).get();
    final nomeProjeto = projeto.data()?['nome'] ?? 'projeto';
    
    await _notificacaoService.enviarNotificacao(
      usuarioId: membroId,
      titulo: 'Novo Projeto',
      corpo: 'Você foi adicionado ao projeto $nomeProjeto',
    );
  }

  Future<void> removerMembro(String projetoId, String membroId) async {
    await _firestore.collection('projetos').doc(projetoId).update({
      'membrosIds': FieldValue.arrayRemove([membroId]),
    });

    final projeto = await _firestore.collection('projetos').doc(projetoId).get();
    final nomeProjeto = projeto.data()?['nome'] ?? 'projeto';
    
    await _notificacaoService.enviarNotificacao(
      usuarioId: membroId,
      titulo: 'Removido do Projeto',
      corpo: 'Você foi removido do projeto $nomeProjeto',
    );
  }

  Stream<List<Map<String, dynamic>>> streamMembros(String projetoId) {
    return _firestore
        .collection('projetos')
        .doc(projetoId)
        .snapshots()
        .asyncMap((doc) async {
      if (!doc.exists) return [];
      
      final membrosIds = List<String>.from(doc.data()?['membrosIds'] ?? []);
      return await buscarMembros(membrosIds);
    });
  }

  Future<bool> verificarPermissao(
    String projetoId,
    String userId,
    NivelPermissao nivelNecessario,
  ) async {
    final snapshot = await _firestore
        .collection('membros_projeto')
        .where('projetoId', isEqualTo: projetoId)
        .where('userId', isEqualTo: userId)
        .get();

    if (snapshot.docs.isEmpty) return false;

    final membro = MembroProjeto.fromJson(
      snapshot.docs.first.data() as Map<String, dynamic>,
    );

    return membro.permissao.index <= nivelNecessario.index;
  }
} 