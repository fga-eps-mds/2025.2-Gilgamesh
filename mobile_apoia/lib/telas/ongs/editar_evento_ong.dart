import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';
import '../../services/auth_service.dart';

class EditarEventoTela extends StatefulWidget {
  final String? eventoId;

  const EditarEventoTela({super.key, this.eventoId});

  @override
  State<EditarEventoTela> createState() => _EditarEventoTelaState();
}

class _EditarEventoTelaState extends State<EditarEventoTela> {
  final EventService _service = EventService();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _carregandoDados = true;

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _vagasController = TextEditingController();

  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  String estadoSelecionado = 'UF';
  
  Event? _eventoOriginal;

  final List<String> _estados = const [
    'UF', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT',
    'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR',
    'SC', 'SP', 'SE', 'TO',
  ];

  @override
  void initState() {
    super.initState();
    _carregarDadosEvento();
  }

  Future<void> _carregarDadosEvento() async {
    if (widget.eventoId == null) {
      setState(() => _carregandoDados = false);
      return;
    }

    try {
      final token = await _authService.getToken();
      if (token == null) return;

      final eventos = await _service.getMeusEventos(token);
      final evento = eventos.firstWhere(
        (e) => e.id.toString() == widget.eventoId,
        orElse: () => throw Exception('Evento não encontrado'),
      );

      setState(() {
        _eventoOriginal = evento;
        _tituloController.text = evento.titulo;
        _descricaoController.text = evento.descricao;
        _vagasController.text = evento.totalVagas.toString();
        _dataSelecionada = evento.date;
        _horaSelecionada = TimeOfDay.fromDateTime(evento.date);
        
        final locationParts = evento.location.split(' - ');
        if (locationParts.isNotEmpty) {
          _enderecoController.text = locationParts[0];
          if (locationParts.length > 1) {
            final uf = locationParts.last.trim();
            if (_estados.contains(uf)) {
              estadoSelecionado = uf;
            }
          }
        }
        
        _carregandoDados = false;
      });
    } catch (e) {
      print('Erro ao carregar evento: $e');
      setState(() => _carregandoDados = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar evento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _dataSelecionada = picked);
    }
  }

  Future<void> _selecionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaSelecionada ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _horaSelecionada = picked);
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
        color: Colors.grey.shade200,
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
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: estadoSelecionado == 'UF' ? null : estadoSelecionado,
          hint: Text(
            "UF",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.azulApoia),
          isExpanded: true,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onChanged: (String? newValue) {
            setState(() => estadoSelecionado = newValue ?? 'UF');
          },
          items: _estados
              .where((item) => item != 'UF')
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
        ),
      ),
    );
  }

  void _salvarEdicao(BuildContext context) async {
    if (_tituloController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O título é obrigatório'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_dataSelecionada == null || _horaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione data e horário'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_vagasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe a quantidade de vagas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        throw Exception('Sessão expirada');
      }

      final DateTime dataFinal = DateTime(
        _dataSelecionada!.year,
        _dataSelecionada!.month,
        _dataSelecionada!.day,
        _horaSelecionada!.hour,
        _horaSelecionada!.minute,
      );

      final eventoAtualizado = Event(
        id: int.parse(widget.eventoId!),
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        location: "${_enderecoController.text} - $estadoSelecionado",
        date: dataFinal,
        totalVagas: int.parse(_vagasController.text),
        participantes: _eventoOriginal?.participantes ?? 0,
        ongId: _eventoOriginal?.ongId ?? 0,
      );

      bool sucesso = await _service.updateEvent(eventoAtualizado, token);

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Evento atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erro ao atualizar evento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String textoData = _dataSelecionada == null
        ? "DATA DE INÍCIO"
        : "${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}";

    String textoHora = _horaSelecionada == null
        ? "HORÁRIO"
        : "${_horaSelecionada!.hour}:${_horaSelecionada!.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.laranjaApoia,
        title: const Text(
          'EDITAR EVENTO',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      
      body: _carregandoDados
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  _buildGrayInput(
                    hintText: 'TÍTULO DO EVENTO',
                    controller: _tituloController,
                    suffixIcon: Icon(
                      Icons.edit_outlined,
                      color: AppColors.azulApoia,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildGrayInput(
                          hintText: 'Endereço / Cidade',
                          controller: _enderecoController,
                          suffixIcon: Icon(
                            Icons.edit_outlined,
                            color: AppColors.azulApoia,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _buildStateDropdown()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildGrayInput(
                          hintText: textoData,
                          readOnly: true,
                          onTap: _selecionarData,
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColors.azulApoia,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildGrayInput(
                          hintText: textoHora,
                          readOnly: true,
                          onTap: _selecionarHora,
                          suffixIcon: Icon(
                            Icons.access_time,
                            color: AppColors.azulApoia,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildGrayInput(
                    hintText: 'QUANTIDADE DE VAGAS',
                    controller: _vagasController,
                    keyboardType: TextInputType.number,
                    suffixIcon: Icon(
                      Icons.group,
                      color: AppColors.azulApoia,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildGrayInput(
                    hintText: 'DESCRIÇÃO',
                    controller: _descricaoController,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.cancel),
                          label: const Text('CANCELAR'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('SALVAR'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _isLoading 
                              ? null 
                              : () => _salvarEdicao(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}