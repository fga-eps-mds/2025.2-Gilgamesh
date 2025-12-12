class Ong {
  final int id;
  final String nome;
  final String email;
  final String endereco;

  Ong({
    required this.id,
    required this.nome,
    required this.email,
    required this.endereco,
  });

  // Converte o JSON do Django para Objeto Dart
  factory Ong.fromJson(Map<String, dynamic> json) {
    return Ong(
      id: json['id'],
      nome: json['nome'] ?? 'Sem Nome',
      email: json['email'] ?? '',
      // Se o campo endereço vier nulo, fica vazio
      endereco: json['endereco'] ?? '',
    );
  }
}
