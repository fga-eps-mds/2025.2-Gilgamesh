class Event {
  final int id;
  final String nome;
  final String descricao;
  final DateTime date;
  final String location;
  final int totalVagas;
  final int participantes;
  final int ongId;

  Event({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.date,
    required this.location,
    required this.totalVagas,
    required this.participantes,
    required this.ongId,
  });
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? 'Sem Nome',
      descricao: json['descricao'] ?? '',
      date: json['data_inicio'] != null 
          ? DateTime.parse(json['data_inicio']) 
          : DateTime.now(),
      location: json['local'] ?? 'Local a definir',
      totalVagas: json['vagas'] ?? 0,
      participantes: json['participantes'] ?? 0,
      ongId: json['ong_id'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'data_inicio': date.toIso8601String(),
      'local': location,
      'vagas': totalVagas,
      'ong_id': ongId,
    };
  }
}