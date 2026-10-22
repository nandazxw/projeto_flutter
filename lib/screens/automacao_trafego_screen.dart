import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AutomacaoTrafegoScreen extends StatefulWidget {
  const AutomacaoTrafegoScreen({super.key});

  @override
  State<AutomacaoTrafegoScreen> createState() => _AutomacaoTrafegoScreenState();
}

class _AutomacaoTrafegoScreenState extends State<AutomacaoTrafegoScreen> {
  bool _foiAgendado = false;
  String? _horarioAgendado;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

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
                child: const Text(
                  '● Sistema de Agendamento Automático Ativo',
                  style: TextStyle(color: Color(0xFFA855F7), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  children: [
                    TextSpan(text: 'Agendamento Inteligente e '),
                    TextSpan(text: 'Pico Orgânico', style: TextStyle(color: Color(0xFFEC4899))),
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
                    Text(
                      'Analisamos o seu nicho (${provider.nicho}) e o histórico de conversas do seu perfil para estimar os melhores horários de retenção e pico orgânico.',
                      style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 600;
                        final cardWidth = isMobile ? double.infinity : (constraints.maxWidth - 32) / 3;

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(width: cardWidth, child: _buildScheduleCard(provider, '18:45', '+45% retenção', 'Maior pico de audiência do seu nicho')),
                            SizedBox(width: cardWidth, child: _buildScheduleCard(provider, '12:30', '+30% engajamento', 'Horário de intervalo do público-alvo')),
                            SizedBox(width: cardWidth, child: _buildScheduleCard(provider, '21:15', '+25% engajamento', 'Pico de consumo noturno')),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA855F7),
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: provider.isScheduling
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.schedule_send_rounded, color: Colors.white, size: 18),
                        label: Text(
                          provider.isScheduling
                              ? 'Agendando no Railway...'
                              : 'Agendar Publicação para ${provider.selectedScheduleTime}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: provider.isScheduling
                            ? null
                            : () async {
                                final success = await provider.confirmarAgendamento();
                                if (!context.mounted) return;
                                setState(() {
                                  _foiAgendado = true;
                                  _horarioAgendado = provider.selectedScheduleTime;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? 'Publicação sincronizada com o backend para às ${provider.selectedScheduleTime}!'
                                        : 'Agendado localmente para às ${provider.selectedScheduleTime}!'),
                                    backgroundColor: const Color(0xFF10B981),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                      ),
                    ),

                    // Mensagem de confirmação de agendamento com sucesso
                    if (_foiAgendado && _horarioAgendado != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Publicação agendada com sucesso!',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Sua publicação foi programada para às $_horarioAgendado! O disparo orgânico acontecerá automaticamente no pico de audiência do nicho "${provider.nicho}" no ${provider.plataforma}.',
                                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '● Status: Agendado para hoje às $_horarioAgendado',
                                      style: const TextStyle(
                                        color: Color(0xFF10B981),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(AppProvider provider, String time, String tag, String desc) {
    final isSelected = provider.selectedScheduleTime == time;

    return GestureDetector(
      onTap: () => provider.selectSchedule(time),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF090A10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFFA855F7) : Colors.white10, width: isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(tag, style: const TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}