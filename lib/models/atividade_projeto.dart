enum TipoAtividade {
  criacaoProjeto,
  atualizacaoProjeto,
  adicaoMembro,
  remocaoMembro,
  alteracaoPermissao,
  mensagemChat,
}

class AtividadeProjeto {
  final String id;
  final String projetoId;
  final String usuarioId;
  final TipoAtividade tipo;
  final Map<String, dynamic> dados;
  final DateTime criadoEm;

  AtividadeProjeto({
    required this.id,
    required this.projetoId,
    required this.usuarioId,
    required this.tipo,
    required this.dados,
    required this.criadoEm,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projetoId': projetoId,
      'usuarioId': usuarioId,
      'tipo': tipo.toString().split('.').last,
      'dados': dados,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }

  factory AtividadeProjeto.fromJson(Map<String, dynamic> json) {
    return AtividadeProjeto(
      id: json['id'],
      projetoId: json['projetoId'],
      usuarioId: json['usuarioId'],
      tipo: TipoAtividade.values.firstWhere(
        (e) => e.toString().split('.').last == json['tipo'],
      ),
      dados: json['dados'],
      criadoEm: DateTime.parse(json['criadoEm']),
    );
  }
} 