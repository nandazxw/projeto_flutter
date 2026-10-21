import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class VisaoGeralScreen extends StatelessWidget {
  const VisaoGeralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final totalScripts = provider.scripts.length;
    final progress = totalScripts > 0 
        ? (provider.roteirosConcluidos / totalScripts).clamp(0.0, 1.0) 
        : 0.0;

    // Métricas calculadas dinamicamente com base nas informações e ações reais do usuário
    final totalReach = provider.calculatedReach;
    String reachFormatted;
    if (totalReach >= 1000000) {
      reachFormatted = '${(totalReach / 1000000).toStringAsFixed(1)}M';
    } else if (totalReach >= 1000) {
      reachFormatted = '${(totalReach / 1000).toStringAsFixed(1)}K';
    } else {
      reachFormatted = '$totalReach';
    }

    final reachGrowthTag = '+${(8.0 + (provider.roteirosConcluidos * 3.5) + (provider.mensagensTrocadas * 0.7) + (provider.tendencias.length * 1.5)).clamp(5.0, 150.0).toStringAsFixed(1)}%';
    final reachDesc = 'Baseado em ${provider.mensagensTrocadas} chats e ${provider.tendencias.length} trends no nicho "${provider.nicho}".';

    final engFormatted = '${provider.calculatedEngagementRate.toStringAsFixed(1)}%';
    final engGrowth = '+${(0.8 + (provider.roteirosConcluidos * 0.6) + (provider.mensagensTrocadas * 0.15)).clamp(0.5, 20.0).toStringAsFixed(1)}%';
    final engDesc = totalScripts > 0 
        ? '${provider.roteirosConcluidos} de $totalScripts roteiros concluídos impulsionando a retenção.'
        : 'Gere roteiros nas trends para impulsionar a retenção.';

    final healthScore = provider.calculatedHealthScore;
    final healthFormatted = '$healthScore/100';
    final healthPoints = '+${((healthScore - 30) / 4).toInt().clamp(2, 25)} pts';

    String healthDesc;
    if (healthScore >= 80) {
      healthDesc = 'Excelente entrega orgânica no nicho "${provider.nicho}".';
    } else if (healthScore >= 60) {
      healthDesc = 'Bom nível de engajamento e consistência.';
    } else {
      healthDesc = 'Em aquecimento. Interaja mais com o bot e pesquise trends.';
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '● Nicho Ativo: ${provider.nicho} | Plataforma: ${provider.plataforma}',
                  style: const TextStyle(color: Color(0xFFA855F7), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  children: [
                    TextSpan(text: 'Painel de '),
                    TextSpan(text: 'Crescimento Dinâmico', style: TextStyle(color: Color(0xFFA855F7))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KPI Cards
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildKpiCard('ALCANCE ESTIMADO', reachFormatted, reachGrowthTag, reachDesc, Icons.people_outline),
                  _buildKpiCard('ENGAJAMENTO MÉDIO', engFormatted, engGrowth, engDesc, Icons.thumb_up_alt_outlined),
                  _buildKpiCard('SAÚDE ORGÂNICA', healthFormatted, healthPoints, healthDesc, Icons.favorite_border),
                ],
              ),
              const SizedBox(height: 24),

              // Status de Execução de Roteiros
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF11131F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progresso do Planejador', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('${(progress * 100).toInt()}% concluído', style: const TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFF1A1D2E),
                      color: const Color(0xFFA855F7),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${provider.roteirosConcluidos} de $totalScripts roteiros executados para o nicho "${provider.nicho}". Quanto mais roteiros gerados a partir das tendências da web, maior a precisão do algoritmo.',
                      style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ações Rápidas Dinâmicas
              const Text('Ações Rápidas Recomendadas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      title: 'Pesquisar Trends',
                      subtitle: 'Buscar novidades na web',
                      icon: Icons.trending_up,
                      onTap: () => provider.setCurrentNavIndex(2),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      title: 'Chat com a IA',
                      subtitle: 'Criar ganchos e roteiros',
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: () => provider.setCurrentNavIndex(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String tag, String desc, IconData icon) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF11131F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
              Icon(icon, color: const Color(0xFFA855F7), size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tag, style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF11131F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFA855F7).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFA855F7), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
