class Projeto {
  final String id;
  final String nome;
  final String descricao;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final List<String> membrosIds;
  final String status;

  Projeto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    this.dataFim,
    required this.membrosIds,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim?.toIso8601String(),
      'membrosIds': membrosIds,
      'status': status,
    };
  }

  factory Projeto.fromJson(Map<String, dynamic> json) {
    return Projeto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      dataInicio: DateTime.parse(json['dataInicio']),
      dataFim: json['dataFim'] != null ? DateTime.parse(json['dataFim']) : null,
      membrosIds: List<String>.from(json['membrosIds']),
      status: json['status'],
    );
  }
} 