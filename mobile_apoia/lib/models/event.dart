class Event {
  final int id;
  final String titulo;
  final String descricao;
  final DateTime date;
  final String location;
  final int totalVagas;
  final int participantes;
  final int ongId;
  final String? nomeOng; // NOVO: armazena o nome da ONG

  Event({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.date,
    required this.location,
    required this.totalVagas,
    required this.participantes,
    required this.ongId,
    this.nomeOng, // NOVO
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Sem Nome',
      descricao: json['descricao'] ?? '',
      date: json['data_inicio'] != null
          ? DateTime.parse(json['data_inicio'])
          : DateTime.now(),
      location: json['local'] ?? 'Local a definir',
      totalVagas: json['vagas'] ?? 0,
      participantes: json['participantes'] ?? 0,
      
      // MODIFICADO: Tenta pegar criado_por_id, se não tiver usa ong_id
      ongId: json['criado_por_id'] ?? json['ong_id'] ?? 0,
      
      // NOVO: Pega o nome da ONG se vier no JSON
      nomeOng: json['criado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'data_inicio': date.toIso8601String(),
      'local': location,
      'vagas': totalVagas,
      'ong_id': ongId,
    };
  }
}