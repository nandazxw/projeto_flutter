import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class PlanejadorConteudoScreen extends StatefulWidget {
  const PlanejadorConteudoScreen({super.key});

  @override
  State<PlanejadorConteudoScreen> createState() => _PlanejadorConteudoScreenState();
}

class _PlanejadorConteudoScreenState extends State<PlanejadorConteudoScreen> {
  String _filter = 'Todos'; // 'Todos', 'Pendentes', 'Concluídos'

  void _showScriptDetailsModal(BuildContext context, ScriptItem script) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF11131F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '🤖 Gerado pelo Chat IA',
                          style: TextStyle(color: Color(0xFFA855F7), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    script.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: SelectableText(
                        script.content.isNotEmpty
                            ? script.content
                            : 'Roteiro elaborado diretamente no chat com o bot.',
                        style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    // Contadores dinâmicos baseados exclusivamente nas ideias geradas pelo chat
    final totalCount = provider.scripts.length;
    final pendentesCount = provider.scripts.where((s) => s.status == 'Pendente').length;
    final concluidosCount = provider.scripts.where((s) => s.status == 'Concluído').length;
    final progress = totalCount > 0 ? (concluidosCount / totalCount).clamp(0.0, 1.0) : 0.0;

    // Filtragem dos roteiros gerados
    final filteredScripts = provider.scripts.where((s) {
      if (_filter == 'Pendentes') {
        return s.status == 'Pendente';
      } else if (_filter == 'Concluídos') {
        return s.status == 'Concluído';
      }
      return true; // 'Todos'
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de Status do Planejador
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '● Roteiros Gerados pelo Chat do Bot',
                  style: TextStyle(color: Color(0xFFA855F7), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Título
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  children: [
                    TextSpan(text: 'Planejador de '),
                    TextSpan(text: 'Roteiros do Chat', style: TextStyle(color: Color(0xFFEC4899))),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Container Principal do Planejador
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11131F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabeçalho Responsivo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ideias e Roteiros Criados',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Todos os roteiros formulados nas suas conversas com o bot aparecem aqui para acompanhamento.',
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.zero,
                              side: const BorderSide(color: Color(0xFFA855F7)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFFA855F7)),
                            label: const Text('Ir ao Chat', style: TextStyle(color: Color(0xFFA855F7), fontSize: 13, fontWeight: FontWeight.bold)),
                            onPressed: () => provider.setCurrentNavIndex(1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Barra de Progresso de Conclusão
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF090A10),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progresso de Gravação: $concluidosCount de $totalCount concluídos',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white10,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Chips de Filtro (Todos, Pendentes, Concluídos)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterChip('Todos', totalCount),
                          _buildFilterChip('Pendentes', pendentesCount),
                          _buildFilterChip('Concluídos', concluidosCount),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Lista de Roteiros
                      Expanded(
                        child: filteredScripts.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                itemCount: filteredScripts.length,
                                itemBuilder: (context, index) {
                                  final script = filteredScripts[index];
                                  final isConcluido = script.status == 'Concluído';

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Material(
                                      color: const Color(0xFF090A10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: isConcluido
                                              ? const Color(0xFF10B981).withValues(alpha: 0.3)
                                              : Colors.white12,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        leading: Checkbox(
                                          value: isConcluido,
                                          activeColor: const Color(0xFF10B981),
                                          checkColor: Colors.white,
                                          side: const BorderSide(color: Colors.white38),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                          onChanged: (_) {
                                            provider.toggleScriptStatus(script.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  isConcluido
                                                      ? 'Roteiro marcado como Pendente.'
                                                      : 'Roteiro concluído com sucesso! 🎉',
                                                ),
                                                backgroundColor: isConcluido
                                                    ? const Color(0xFFA855F7)
                                                    : const Color(0xFF10B981),
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                        ),
                                        title: Text(
                                          script.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isConcluido ? FontWeight.normal : FontWeight.w600,
                                            color: isConcluido ? Colors.grey : Colors.white,
                                            decoration: isConcluido ? TextDecoration.lineThrough : null,
                                            decorationColor: Colors.grey,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 6.0),
                                          child: Wrap(
                                            spacing: 8,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: isConcluido
                                                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                                      : const Color(0xFFA855F7).withValues(alpha: 0.15),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  isConcluido ? '● Concluído' : '● Pendente',
                                                  style: TextStyle(
                                                    color: isConcluido ? const Color(0xFF10B981) : const Color(0xFFA855F7),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Text(
                                                '• Chat IA',
                                                style: TextStyle(color: Colors.grey, fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (script.content.isNotEmpty)
                                              IconButton(
                                                icon: const Icon(Icons.visibility_outlined, color: Colors.grey, size: 20),
                                                tooltip: 'Ver roteiro completo',
                                                onPressed: () => _showScriptDetailsModal(context, script),
                                              ),
                                            IconButton(
                                              icon: Icon(
                                                isConcluido ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                                                color: isConcluido ? const Color(0xFFA855F7) : const Color(0xFF10B981),
                                                size: 20,
                                              ),
                                              tooltip: isConcluido ? 'Mover para Pendente' : 'Marcar como Concluído',
                                              onPressed: () {
                                                provider.toggleScriptStatus(script.id);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey, size: 20),
                                              tooltip: 'Excluir roteiro',
                                              onPressed: () {
                                                provider.deleteScript(script.id);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Roteiro removido do planejador.'),
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          if (script.content.isNotEmpty) {
                                            _showScriptDetailsModal(context, script);
                                          } else {
                                            provider.toggleScriptStatus(script.id);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _filter == label;
    return ChoiceChip(
      label: Text(
        '$label ($count)',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFFA855F7),
      backgroundColor: const Color(0xFF090A10),
      side: BorderSide(
        color: isSelected ? const Color(0xFFA855F7) : Colors.white12,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (_) => setState(() => _filter = label),
    );
  }

  Widget _buildEmptyState() {
    IconData icon;
    String title;
    String subtitle;

    if (_filter == 'Pendentes') {
      icon = Icons.task_alt_rounded;
      title = 'Nenhum roteiro pendente!';
      subtitle = 'Todos os roteiros gerados no chat foram marcados como concluídos.';
    } else if (_filter == 'Concluídos') {
      icon = Icons.hourglass_empty_rounded;
      title = 'Nenhum roteiro concluído ainda.';
      subtitle = 'Marque os roteiros como concluídos conforme for gravando e publicando seus vídeos.';
    } else {
      icon = Icons.chat_bubble_outline_rounded;
      title = 'Nenhum roteiro gerado no chat ainda.';
      subtitle = 'Peça ao bot no chat para criar um roteiro ou ideia de vídeo (ou use o botão "Criar Roteiro" nas Trends) para que apareça aqui automaticamente!';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFFA855F7)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
