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
      id: json['id_evento'],
      nome: json['nome_evento'],
      descricao: json['descricao_evento'],
      date: DateTime.parse(json['data_evento']),
      location: json['localizacao_evento'],
      totalVagas: json['vagas_total'],
      participantes: json['numero_participantes'],
      ongId: json['ong_id'],
    );
  }
}
