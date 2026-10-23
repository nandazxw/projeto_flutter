import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../screens/welcome_screen.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({super.key});

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _nichoController;
  late TextEditingController _plataformaController;
  late TextEditingController _tomDeVozController;
  late TextEditingController _estrategiaController;

  @override
  void initState() {
    super.initState();
    final p = Provider.of<AppProvider>(context, listen: false);
    _nameController = TextEditingController(text: p.userName);
    _handleController = TextEditingController(text: p.userHandle);
    _nichoController = TextEditingController(text: p.nicho);
    _plataformaController = TextEditingController(text: p.plataforma);
    _tomDeVozController = TextEditingController(text: p.tomDeVoz);
    _estrategiaController = TextEditingController(text: p.estrategia);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Dialog(
      backgroundColor: const Color(0xFF11131F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.verified_user_outlined, color: Color(0xFFA855F7)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Perfil do Criador de Conteúdo IA',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF090A10), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFA855F7),
                      child: Text(
                        provider.userName.isNotEmpty ? provider.userName.substring(0, 2).toUpperCase() : 'CV',
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(provider.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(provider.userHandle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFA855F7).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Plano Pro (IA Unlocked)', style: TextStyle(color: Color(0xFFA855F7), fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.edit, size: 14, color: Color(0xFFA855F7)),
                      label: const Text('Editar', style: TextStyle(color: Color(0xFFA855F7))),
                      onPressed: () => _showEditDialog(context, provider),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('⚙️ Preferências de Produção com IA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 450;
                  final cardWidth = isMobile ? double.infinity : (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(width: cardWidth, child: _buildPreferenceCard('Nicho de Atuação', provider.nicho, Icons.track_changes)),
                      SizedBox(width: cardWidth, child: _buildPreferenceCard('Plataforma Alvo', provider.plataforma, Icons.layers)),
                      SizedBox(width: cardWidth, child: _buildPreferenceCard('Tom de Voz Padrão', provider.tomDeVoz, Icons.record_voice_over)),
                      SizedBox(width: cardWidth, child: _buildPreferenceCard('Estratégia de Retenção', provider.estrategia, Icons.bolt)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('📈 Métricas do Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF090A10), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Conversas com o Bot:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('${provider.mensagensTrocadas} interações', style: const TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF090A10), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Roteiros Concluídos:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('${provider.roteirosConcluidos} roteiros', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                  label: const Text(
                    'Sair da Conta',
                    style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  onPressed: () async {
                    final provider = Provider.of<AppProvider>(context, listen: false);
                    Navigator.pop(context); // Fecha o modal
                    await provider.logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF090A10), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFFA855F7)),
              const SizedBox(width: 6),
              Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF11131F),
        title: const Text('Editar Perfil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: _handleController, decoration: const InputDecoration(labelText: 'Handle')),
              TextField(controller: _nichoController, decoration: const InputDecoration(labelText: 'Nicho')),
              TextField(controller: _plataformaController, decoration: const InputDecoration(labelText: 'Plataforma')),
              TextField(controller: _tomDeVozController, decoration: const InputDecoration(labelText: 'Tom de Voz')),
              TextField(controller: _estrategiaController, decoration: const InputDecoration(labelText: 'Estratégia')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA855F7)),
            onPressed: () {
              provider.updateProfile(
                name: _nameController.text,
                handle: _handleController.text,
                nicho: _nichoController.text,
                plataforma: _plataformaController.text,
                tomDeVoz: _tomDeVozController.text,
                estrategia: _estrategiaController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}