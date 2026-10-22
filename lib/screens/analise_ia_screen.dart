import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AnaliseIaScreen extends StatelessWidget {
  const AnaliseIaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    // Cálculos dinâmicos em tempo real com base no que o usuário digitou e nas trends ativas
    final engRate = provider.calculatedEngagementRate;
    final totalReach = provider.calculatedReach;
    final healthScore = provider.calculatedHealthScore;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '● Análise Preditiva em Tempo Real: Nicho "${provider.nicho}"',
                style: const TextStyle(color: Color(0xFFA855F7), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                children: [
                  TextSpan(text: 'Análise Avançada de '),
                  TextSpan(text: 'Engajamento e IA', style: TextStyle(color: Color(0xFFEC4899))),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                  const Text('Métricas Calculadas em Tempo Real', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    'Cruzamento instantâneo entre o texto digitado pelo usuário (${provider.totalCaracteresDigitados} caracteres informados), ${provider.mensagensTrocadas} interações com o assistente e ${provider.tendencias.length} tendências mapeadas na web.',
                    style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 650;
                      final cardWidth = isMobile
                          ? double.infinity
                          : (constraints.maxWidth > 960 ? (constraints.maxWidth - 32) / 3 : (constraints.maxWidth - 16) / 2);

                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: _buildMetricBox(
                              'TAXA DE ENGAJAMENTO DINÂMICA',
                              '${engRate.toStringAsFixed(1)}%',
                              'Calculada diretamente com base na sua densidade de interação e trends ativas',
                              isHighlight: true,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _buildMetricBox(
                              'ALCANCE POTENCIAL ESTIMADO',
                              totalReach >= 1000 ? '${(totalReach / 1000).toStringAsFixed(1)}K' : '$totalReach',
                              'Projeção de visualizações orgânicas para o nicho "${provider.nicho}"',
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _buildMetricBox(
                              'SCORE DE SAÚDE ORGÂNICA',
                              '$healthScore/100',
                              'Compatibilidade com o algoritmo do ${provider.plataforma}',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090A10),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.insights, color: Color(0xFFA855F7), size: 18),
                            SizedBox(width: 8),
                            Text('Diagnóstico Estratégico da IA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Para o tema "${provider.nicho}", seus roteiros e mensagens indicam uma taxa de conversão projetada em ${engRate.toStringAsFixed(1)}%. '
                          'Ao utilizar os ganchos gerados nas tendências em alta, sua retenção nos primeiros 3 segundos aumenta significativamente no ${provider.plataforma}.',
                          style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildMetricBox(String title, String value, String desc, {bool isHighlight = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFF201335) : const Color(0xFF090A10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlight ? const Color(0xFFA855F7) : Colors.white10,
          width: isHighlight ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isHighlight ? const Color(0xFFA855F7) : Colors.grey)),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.3)),
        ],
      ),
    );
  }
}
