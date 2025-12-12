import 'package:flutter/material.dart';
import '../../services/event_service.dart';
import '../../models/event.dart';
import '../../telas/doador/tela_perfil_usuario.dart';
import '../../widgets/event_card.dart';
import '../../widgets/ong_card.dart'; // IMPORT NOVO
import '../../widgets/barra_inferior_superior_tela_doador.dart';
import '../../widgets/barra_de_pesquisa.dart';

class HomeUsuario extends StatefulWidget {
  const HomeUsuario({super.key});

  @override
  State<HomeUsuario> createState() => _HomeUsuarioState();
}

class _HomeUsuarioState extends State<HomeUsuario> {
  final SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();
  final EventService _eventService = EventService();
  
  List<Event> _eventosReais = [];
  List<Event> _eventosFiltrados = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarEventosDoBanco();
  }

  void _carregarEventosDoBanco() async {
    try {
      List<Event> eventos = await _eventService.getEvents(); 
      setState(() {
        _eventosReais = eventos;
        _eventosFiltrados = eventos;
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar eventos: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperiorBarDoador(),
      body: SingleChildScrollView( // Permite rolar a tela toda para baixo
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TÍTULO EVENTOS ---
              const Text(
                "Campanhas ativas",
                style: TextStyle(fontSize: 22, color: Color(0xFF1E5AA8), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // BARRA DE PESQUISA
              SearchAnchor(
                searchController: searchController,
                builder: (context, controller) {
                  return BarraDePesquisa(
                    onTap: () => controller.openView(),
                    onChanged: (value) {}, 
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return [const ListTile(title: Text("Pesquisa em breve..."))];
                },
              ),
              const SizedBox(height: 16),

              -
              SizedBox(
                height: 230, 
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _eventosFiltrados.isEmpty 
                      ? const Center(child: Text("Nenhuma campanha encontrada."))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _eventosFiltrados.length,
                          itemBuilder: (context, index) {
                            return EventCard(
                              event: _eventosFiltrados[index],
                              onTap: () {},
                            );
                          },
                        ),
              ),

              const SizedBox(height: 30),

              // ONGS PARCEIRAS 
              const Text(
                "ONGs Parceiras",
                style: TextStyle(fontSize: 22, color: Color(0xFF1E5AA8), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // CARROSSEL DE ONGS (MOCKADO PARA O VISUAL)
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    OngCard(nome: "Mãos que Ajudam", categoria: "Assistência", id: 1, onTap: () {}),
                    OngCard(nome: "EcoVida", categoria: "Meio Ambiente", id: 2, onTap: () {}),
                    OngCard(nome: "PetFeliz", categoria: "Animais", id: 3, onTap: () {}),
                    OngCard(nome: "Educa+", categoria: "Educação", id: 4, onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaPerfilUsuario(isOng: false)));
          }
        },
      ),
    );
  }
}