enum NivelPermissao {
  admin,
  editor,
  visualizador,
}

class MembroProjeto {
  final String userId;
  final String projetoId;
  final NivelPermissao permissao;
  final DateTime adicionadoEm;

  MembroProjeto({
    required this.userId,
    required this.projetoId,
    required this.permissao,
    required this.adicionadoEm,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'projetoId': projetoId,
      'permissao': permissao.toString().split('.').last,
      'adicionadoEm': adicionadoEm.toIso8601String(),
    };
  }

  factory MembroProjeto.fromJson(Map<String, dynamic> json) {
    return MembroProjeto(
      userId: json['userId'],
      projetoId: json['projetoId'],
      permissao: NivelPermissao.values.firstWhere(
        (e) => e.toString().split('.').last == json['permissao'],
      ),
      adicionadoEm: DateTime.parse(json['adicionadoEm']),
    );
  }
} 