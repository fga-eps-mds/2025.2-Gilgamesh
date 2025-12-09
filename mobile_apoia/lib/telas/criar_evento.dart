import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/barra_inferior_e_superior.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';
import '../../services/auth_service.dart'; 

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
  
  final EventService _service = EventService();
  final AuthService _authService = AuthService(); 
  bool _isLoading = false;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _vagasController = TextEditingController(); 

  // Variáveis para guardar Data e Hora escolhidas
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;

  String estadoSelecionado = 'UF';
  final List<String> _estados = const [
    'UF', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 
    'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _enderecoController.dispose();
    _descricaoController.dispose();
    _vagasController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _horaSelecionada = picked;
      });
    }
  }

  Widget _buildGrayInput({
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
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
          readOnly: readOnly, 
          onTap: onTap,
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
            "UF",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
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

  void _criarEvento(BuildContext context) async {
    print("--- INICIANDO PROCESSO DE CRIAÇÃO ---");

    // Validação básica
    if (_tituloController.text.isEmpty || 
        _dataSelecionada == null || 
        _horaSelecionada == null ||
        _vagasController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Preencha Título, Data, Hora e Vagas!'))
       );
       return;
    }

    setState(() => _isLoading = true);

    // Busca Usuário Logado
    final dadosUsuario = await _authService.getUsuarioSalvo();
    int idUsuarioLogado = 0;

    if (dadosUsuario != null && dadosUsuario['id'] != null) {
      idUsuarioLogado = dadosUsuario['id'];
      print("-> Usuário Identificado: ID $idUsuarioLogado");
    } else {
      print("-> ERRO: Token inválido ou usuário deslogado.");
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Faça login novamente.'), backgroundColor: Colors.red)
      );
      return;
    }

    // dia + hora)
    final DateTime dataFinal = DateTime(
      _dataSelecionada!.year,
      _dataSelecionada!.month,
      _dataSelecionada!.day,
      _horaSelecionada!.hour,
      _horaSelecionada!.minute,
    );

    // Cria Objeto
    final novoEvento = Event(
      id: 0, 
      nome: _tituloController.text,
      descricao: _descricaoController.text,
      location: "${_enderecoController.text} - $estadoSelecionado",
      date: dataFinal, 
      totalVagas: int.tryParse(_vagasController.text) ?? 10, 
      participantes: 0,
      ongId: idUsuarioLogado, 
    );

    // Ver se está mandando certo
    print("--- ENVIANDO DADOS PARA O BANCO (DJANGO) ---");
    print("Evento: ${novoEvento.nome}");
    print("Data/Hora: ${novoEvento.date}");
    print("Vagas: ${novoEvento.totalVagas}");
    print("ONG ID: ${novoEvento.ongId}");
    print("--------------------------------------------");

    bool sucesso = await _service.createEvent(novoEvento);

    setState(() => _isLoading = false);

    if (sucesso) {
      print("-> RESPOSTA DO BANCO: 201 Created (Sucesso!)"); // Log de sucesso
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento salvo com sucesso!'), backgroundColor: Colors.green),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      print("-> RESPOSTA DO BANCO: Falha/Erro"); // Log de erro
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão com o servidor.'), backgroundColor: Colors.red),
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
    // Formata textos para os campos
    String textoData = _dataSelecionada == null 
        ? "DATA DE INÍCIO" 
        : "${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}";
    
    String textoHora = _horaSelecionada == null 
        ? "HORÁRIO" 
        : "${_horaSelecionada!.hour}:${_horaSelecionada!.minute.toString().padLeft(2, '0')}";

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
              const Center(child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator())),

            // TÍTULO
            _buildGrayInput(
              hintText: 'TITULO DO EVENTO',
              controller: _tituloController,
              suffixIcon: const Icon(Icons.edit_outlined, color: corAzulTexto, size: 24),
            ),
            const SizedBox(height: 20.0),

            // ENDEREÇO
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

            // DATA + HORA 
            Row(
              children: [
                Expanded(
                  child: _buildGrayInput(
                    hintText: textoData,
                    readOnly: true,
                    onTap: _selecionarData, 
                    suffixIcon: const Icon(Icons.calendar_month, color: corAzulTexto, size: 24),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGrayInput(
                    hintText: textoHora,
                    readOnly: true,
                    onTap: _selecionarHora, // Abre relógio
                    suffixIcon: const Icon(Icons.access_time, color: corAzulTexto, size: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // VAGAS
            _buildGrayInput(
              hintText: 'QUANTIDADE DE PARTICIPANTES',
              controller: _vagasController,
              keyboardType: TextInputType.number, // Teclado numérico
              suffixIcon: const Icon(Icons.group, color: corAzulTexto, size: 24),
            ),
            const SizedBox(height: 20.0),

            // DESCRIÇÃO
            _buildGrayInput(
              hintText: 'DESCRIÇÃO',
              controller: _descricaoController,
              maxLines: 5,
            ),
            const SizedBox(height: 40.0),

            // BOTÕES
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