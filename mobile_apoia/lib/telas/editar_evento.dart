import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/barra_inferior_e_superior.dart';

// Cores
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

      title: const Text(
        "Apoia+",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class EditarEventoTela extends StatefulWidget {
  final String? eventoId;

  const EditarEventoTela({super.key, this.eventoId});

  @override
  State<EditarEventoTela> createState() => _EditarEventoTelaState();
}

class _EditarEventoTelaState extends State<EditarEventoTela> {
  int _selectedIndex = 0;

  final TextEditingController _tituloController = TextEditingController(
    text: 'Campanha de Doação de roupas',
  );
  final TextEditingController _enderecoController = TextEditingController(
    text: 'Ponte alta, Gama',
  );
  final TextEditingController _horarioController = TextEditingController(
    text: '10:00 - 16:00',
  );
  final TextEditingController _fotoController = TextEditingController(
    text: 'foto_capa.jpg',
  );
  final TextEditingController _descricaoController = TextEditingController(
    text: 'Doe para quem precisa!',
  );

  String estadoSelecionado = 'DF';
  final List<String> _estados = const [
    'UF',
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
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
    required TextEditingController controller,
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
          value: estadoSelecionado,
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
            if (newValue != null && newValue != 'UF') {
              setState(() {
                estadoSelecionado = newValue;
              });
            }
          },
          items: _estados
              .where((item) => item != 'UF')
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                );
              })
              .toList(),
        ),
      ),
    );
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

  void _salvarEdicao(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '✅ ALTERAÇÕES FEITAS COM SUCESSO! Voltando para listagem...',
        ),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
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
            // Título
            const Center(
              child: Text(
                'EDIÇÃO DE INFORMAÇÕES',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: corAzulTexto,
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            _buildGrayInput(
              hintText: 'TITULO DO EVENTO',
              controller: _tituloController,
              suffixIcon: const Icon(
                Icons.edit_outlined,
                color: corAzulTexto,
                size: 24,
              ),
            ),
            const SizedBox(height: 20.0),

            Row(
              children: [
                Expanded(
                  child: _buildGrayInput(
                    hintText: 'Endereço / Cidade',
                    controller: _enderecoController,
                    suffixIcon: const Icon(
                      Icons.edit_outlined,
                      color: corAzulTexto,
                      size: 24,
                    ),
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
                onTap: () => print('Abrir seletor de fotos'),
                child: const Icon(
                  Icons.file_download,
                  color: corAzulTexto,
                  size: 24,
                ),
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
                  text: 'SALVAR ALTERAÇÕES',
                  color: Colors.green.shade600,
                  onTap: () => _salvarEdicao(context),
                ),

                _buildActionButton(
                  icon: Icons.cancel_outlined,
                  text: 'SAIR SEM SALVAR',
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
