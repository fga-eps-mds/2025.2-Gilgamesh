import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/barra_inferior_e_superior.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';

// Cores tema
const Color corAzulTexto = Color(0xFF007AFF);
const Color corCinzaInput = Color(0xFFEFEFEF);
const Color corLaranjaONG = Color(0xFFFF9900);

class BarraSuperiorONG extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  const BarraSuperiorONG({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: corLaranjaONG,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: const Logo(),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CriarEventoTela extends StatefulWidget {
  const CriarEventoTela({super.key});

  @override
  State<CriarEventoTela> createState() => _CriarEventoTelaState();
}

class _CriarEventoTelaState extends State<CriarEventoTela> {
  int _selectedIndex = 0;
  
  // conectar na API
  final EventService _service = EventService();
  bool _isLoading = false;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final TextEditingController _fotoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  String estadoSelecionado = 'UF';
  final List<String> _estados = const [
    'UF', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 
    'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _enderecoController.dispose();
    _horarioController.dispose();
    _fotoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Widget _buildGrayInput({
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    double height = (maxLines > 1) ? 100 : 48;

    return Container(
      height: height,
      padding: const EdgeInsets.only(left: 15, right: 8),
      decoration: BoxDecoration(
        color: corCinzaInput,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText.toUpperCase(),
            hintStyle: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            suffixIcon: suffixIcon,
            contentPadding: (maxLines > 1)
                ? const EdgeInsets.symmetric(vertical: 10)
                : const EdgeInsets.fromLTRB(0, 5, 0, 5),
          ),
        ),
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: corCinzaInput,
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: estadoSelecionado == 'UF' ? null : estadoSelecionado,
          hint: Text(
            "ESTADO (UF)",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: corAzulTexto),
          isExpanded: true,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onChanged: (String? newValue) {
            setState(() {
              estadoSelecionado = newValue ?? 'UF';
            });
          },
          items: _estados
              .where((item) => item != 'UF')
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              child: Text(value),
              value: value,
            );
          }).toList(),
        ),
      ),
    );
  }

  // Lógica para enviar o evento para o backend
  void _criarEvento(BuildContext context) async {
    print("Tentando criar evento: ${_tituloController.text}");

    // Validação simples
    if (_tituloController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('O título é obrigatório!'))
       );
       return;
    }

    setState(() {
      _isLoading = true;
    });

    //  define para amanhã
    DateTime dataPadrao = DateTime.now().add(const Duration(days: 1));

    final novoEvento = Event(
      id: 0, 
      nome: _tituloController.text,
      descricao: _descricaoController.text,
      location: "${_enderecoController.text} - $estadoSelecionado",
      date: dataPadrao, 
      totalVagas: 50,
      participantes: 0,
      ongId: 1, 
    );

    // Chama API
    bool sucesso = await _service.createEvent(novoEvento);

    setState(() {
      _isLoading = false;
    });

    if (sucesso) {
      print("Evento criado com sucesso!");
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Evento salvo com sucesso!'), 
          backgroundColor: Colors.green
        ),
      );
      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.of(context).pop();
      });

    } else {
      print("Erro ao criar evento na API");
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Erro de conexão com o servidor.'), 
          backgroundColor: Colors.red
        ),
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 50),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraSuperiorONG(onBack: () => Navigator.of(context).pop()),
      bottomNavigationBar: BottomNavBar(
        iconSelecionado: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Text(
                'CRIAR EVENTO',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: corAzulTexto,
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            if (_isLoading) 
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                )
              ),

            _buildGrayInput(
              hintText: 'TITULO DO EVENTO',
              controller: _tituloController,
              suffixIcon: const Icon(Icons.edit_outlined, color: corAzulTexto, size: 24),
            ),
            const SizedBox(height: 20.0),

            Row(
              children: [
                Expanded(
                  child: _buildGrayInput(
                    hintText: 'Endereço / Cidade',
                    controller: _enderecoController,
                    suffixIcon: const Icon(Icons.edit_outlined, color: corAzulTexto, size: 24),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: _buildStateDropdown()),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildGrayInput(
              hintText: 'HORÁRIO',
              controller: _horarioController,
            ),
            const SizedBox(height: 20.0),
            _buildGrayInput(
              hintText: 'FOTO DE DIVULGAÇÃO',
              controller: _fotoController,
              suffixIcon: InkWell(
                onTap: () => print('TODO: Implementar upload de foto'),
                child: const Icon(Icons.file_download, color: corAzulTexto, size: 24),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildGrayInput(
              hintText: 'DESCRIÇÃO',
              controller: _descricaoController,
              maxLines: 5,
            ),
            const SizedBox(height: 40.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.check_circle_outline,
                  text: 'CRIAR EVENTO',
                  color: Colors.green.shade600,
                  onTap: () => _criarEvento(context),
                ),
                _buildActionButton(
                  icon: Icons.cancel_outlined,
                  text: 'SAIR SEM CRIAR',
                  color: Colors.red.shade600,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}