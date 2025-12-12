import 'package:flutter/material.dart';
import '../../services/event_service.dart'; // <--- AGORA USA O SERVIÇO REAL
import '../../models/event.dart';
import '../../telas/doador/tela_perfil_usuario.dart';
import '../../widgets/event_card.dart';
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
  
  // Serviço para buscar dados
  final EventService _eventService = EventService();
  
  List<Event> _eventosReais = []; // Lista que vem do banco
  List<Event> _eventosFiltrados = [];
  bool _isLoading = true; // Para controlar o carregamento

  @override
  void initState() {
    super.initState();
    _carregarEventosDoBanco();
  }

  // --- BUSCA DADOS NA API ---
  void _carregarEventosDoBanco() async {
    try {
      // Tenta buscar todos os eventos
      // (Supondo que seu service tenha um método getEvents ou getAllEvents)
      List<Event> eventos = await _eventService.getEvents(); 
      
      setState(() {
        _eventosReais = eventos;
        _eventosFiltrados = eventos;
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar eventos: $e");
      // Se der erro, para de carregar e deixa a lista vazia (ou mostra erro)
      setState(() {
        _isLoading = false;
      });
    }
  }

  void scrollRight() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.offset + 250,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperiorBarDoador(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Campanhas ativas",
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF1E5AA8),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // BARRA DE PESQUISA
            SearchAnchor(
              searchController: searchController,
              builder: (context, controller) {
                return BarraDePesquisa(
                  onTap: () => controller.openView(),
                  onChanged: (value) {
                    controller.text = value;
                    setState(() {
                      final txt = value.toLowerCase();
                      _eventosFiltrados = _eventosReais.where((evento) {
                        return evento.nome.toLowerCase().contains(txt) ||
                            evento.descricao.toLowerCase().contains(txt) ||
                            evento.location.toLowerCase().contains(txt);
                      }).toList();
                    });
                  },
                );
              },
              suggestionsBuilder: (context, controller) {
                final txt = controller.text.toLowerCase();
                final sugestoes = _eventosReais.where((evento) {
                  return evento.nome.toLowerCase().contains(txt);
                }).toList();

                if (sugestoes.isEmpty) {
                  return const [ListTile(title: Text("Nenhum evento encontrado"))];
                }

                return sugestoes.map((evento) {
                  return ListTile(
                    title: Text(evento.nome),
                    onTap: () {
                      controller.closeView(evento.nome);
                      setState(() => _eventosFiltrados = [evento]);
                    },
                  );
                }).toList();
              },
            ),

            const SizedBox(height: 16),

            // --- CARROSSEL DE EVENTOS (COM LOADING) ---
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) // Mostra loading se estiver carregando
                : _eventosFiltrados.isEmpty 
                    ? const Center(child: Text("Nenhuma campanha encontrada."))
                    : Stack(
                        children: [
                          SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _eventosFiltrados
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: EventCard(
                                        event: e,
                                        onTap: () => print("Clicou em ${e.nome}"),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                          // Seta para direita (só mostra se tiver muitos eventos)
                          if (_eventosFiltrados.length > 1)
                            Positioned(
                              right: 0,
                              top: 90,
                              child: GestureDetector(
                                onTap: scrollRight,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2DB38A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              materialPageRoute(builder: (context) => const TelaPerfilUsuario(isOng: false)), // Assumindo doador
            );
          }
        },
      ),
    );
  }
  
  // Helper para rota (caso precise)
  MaterialPageRoute materialPageRoute({required Widget Function(BuildContext) builder}) {
    return MaterialPageRoute(builder: builder);
  }
}