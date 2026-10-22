import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class BotTendenciasScreen extends StatefulWidget {
  const BotTendenciasScreen({super.key});

  @override
  State<BotTendenciasScreen> createState() => _BotTendenciasScreenState();
}

class _BotTendenciasScreenState extends State<BotTendenciasScreen> {
  late final TextEditingController _nichoController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppProvider>(context, listen: false);
    _nichoController = TextEditingController(text: provider.nicho);
  }

  @override
  void dispose() {
    _nichoController.dispose();
    super.dispose();
  }

  void _pesquisar(AppProvider provider) {
    final temaDigitado = _nichoController.text.trim();
    if (temaDigitado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite um tema ou nicho para pesquisar tendências na web.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    provider.analisarTendenciasWeb(temaDigitado);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de Status do Bot
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '● Mapeamento em Tempo Real via IA & Web (Groq)',
                  style: TextStyle(
                    color: Color(0xFFA855F7),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Título Principal
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(text: 'Bot de '),
                    TextSpan(
                      text: 'Tendências Virais',
                      style: TextStyle(color: Color(0xFFA855F7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Card Dinâmico de Configuração do Tema
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF11131F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tune_rounded, color: Color(0xFFA855F7), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Defina o Tema de Pesquisa',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Digite qualquer assunto para que a IA busque e gere tendências magnéticas, com ganchos de alta retenção e cálculo de engajamento:',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 550;

                        final textField = TextField(
                          controller: _nichoController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Ex: Inteligência Artificial, Finanças, Humor, Moda...',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFF090A10),
                            prefixIcon: const Icon(Icons.tag_rounded, color: Color(0xFFA855F7), size: 18),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFA855F7), width: 1.5),
                            ),
                          ),
                          onSubmitted: (_) => _pesquisar(provider),
                        );

                        final searchButton = ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA855F7),
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: provider.isLoadingTendencias
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 18),
                          label: Text(
                            provider.isLoadingTendencias ? 'Gerando Trends...' : 'Pesquisar na Web',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: provider.isLoadingTendencias ? null : () => _pesquisar(provider),
                        );

                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              textField,
                              const SizedBox(height: 12),
                              searchButton,
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(child: textField),
                            const SizedBox(width: 12),
                            searchButton,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    // Sugestões Rápidas de Nichos Populares
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Inteligência Artificial',
                        'Finanças & Investimentos',
                        'Marketing Digital',
                        'Fitness & Nutrição',
                        'Games & Notícias',
                      ].map((tag) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            _nichoController.text = tag;
                            _pesquisar(provider);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Seção da Lista de Tendências
              if (provider.isLoadingTendencias)
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Color(0xFFA855F7)),
                        SizedBox(height: 12),
                        Text('Conectando ao modelo de IA e mapeando tendências na web...', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                )
              else if (provider.rawTendencias.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(
                    child: Text(
                      'Nenhuma tendência mapeada até o momento.\nDigite um tema e clique em "Pesquisar na Web".',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else ...[
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Color(0xFFA855F7), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Trends em Alta para: ${provider.nicho} (Média: +${provider.mediaScoreTrends.toStringAsFixed(0)}% retenção)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...provider.rawTendencias.map(
                  (item) => _buildTrendCard(context, provider, item),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Card Individual de Tendência com detalhes de gancho e tags
  Widget _buildTrendCard(
    BuildContext context,
    AppProvider provider,
    TrendModel item,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11131F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 560;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${item.growthScore}% retenção',
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    item.categoria,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item.descricao.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  item.descricao,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                ),
              ],
              if (item.hook.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090A10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flash_on, color: Color(0xFFA855F7), size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Gancho (0-3s): "${item.hook}"',
                          style: const TextStyle(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  item.tags,
                  style: const TextStyle(color: Color(0xFFA855F7), fontSize: 11),
                ),
              ],
            ],
          );

          final button = OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              side: const BorderSide(color: Color(0xFFA855F7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFA855F7), size: 16),
            label: const Text(
              'Criar Roteiro',
              style: TextStyle(color: Color(0xFFA855F7), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              provider.criarRoteiroComBot(item.titulo);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Roteiro encaminhado para o Chat com o Bot!'),
                  backgroundColor: Color(0xFFA855F7),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: button),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: content),
              const SizedBox(width: 12),
              button,
            ],
          );
        },
      ),
    );
  }
}
