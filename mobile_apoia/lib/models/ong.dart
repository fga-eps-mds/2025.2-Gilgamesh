class Ong {
  final int id;
  final String nome;
  final String email;
  final String endereco;
  final String telefone;
  final String descricao;

  Ong({
    required this.id,
    required this.nome,
    required this.email,
    required this.endereco,
    required this.telefone,
    required this.descricao,
  });

  // Converte o JSON do Django para Objeto Dart
  factory Ong.fromJson(Map<String, dynamic> json) {
    return Ong(
      id: json['id'],
      nome: json['nome'] ?? 'Sem Nome',
      email: json['email'] ?? '',
      // Se o campo endereço vier nulo, fica vazio
      endereco: json['endereco'] ?? '',
      telefone: json['telefone'] ?? '',
      descricao: json['descricao'] ?? '',
    );
  }
}
