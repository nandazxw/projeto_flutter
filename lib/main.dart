import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/analise_ia_screen.dart';
import 'screens/automacao_trafego_screen.dart';
import 'screens/bot_tendencias_screen.dart';
import 'screens/chat_bot_screen.dart';
import 'screens/planejador_conteudo_screen.dart';
import 'screens/visao_geral_screen.dart';
import 'widgets/profile_modal.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const ViralMindApp(),
    ),
  );
}

class ViralMindApp extends StatelessWidget {
  const ViralMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViralMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _screens = const [
    VisaoGeralScreen(),
    ChatBotScreen(),
    BotTendenciasScreen(),
    AutomacaoTrafegoScreen(),
    AnaliseIaScreen(),
    PlanejadorConteudoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(context, provider),
          Expanded(
            child: IndexedStack(
              index: provider.currentNavIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContent(context, provider)),
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('ViralMind', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFF11131F),
            ),
    );
  }

  Widget _buildSidebar(BuildContext context, AppProvider provider) {
    return Container(
      width: 260,
      color: const Color(0xFF0D0E17),
      child: _buildSidebarContent(context, provider),
    );
  }

  Widget _buildSidebarContent(BuildContext context, AppProvider provider) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFFA855F7), size: 28),
                SizedBox(width: 10),
                Text(
                  'ViralMind',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Lista de Navegação Protegida contra estouro
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavItem(context, provider, 0, Icons.bar_chart_rounded, 'Visão Geral'),
                  _buildNavItem(context, provider, 1, Icons.chat_bubble_outline_rounded, 'Chat com o Bot', badge: 'IA'),
                  _buildNavItem(context, provider, 2, Icons.trending_up_rounded, 'Bot de Tendências'),
                  _buildNavItem(context, provider, 3, Icons.access_time_rounded, 'Automação de Tráfego'),
                  _buildNavItem(context, provider, 4, Icons.psychology_outlined, 'Análise da IA'),
                  _buildNavItem(context, provider, 5, Icons.calendar_today_rounded, 'Planejador de Conteúdo'),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white10),
          // Footer Profile Button
          Builder(
            builder: (dialogContext) => InkWell(
              onTap: () => showDialog(
                context: dialogContext,
                builder: (_) => const ProfileModal(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFA855F7),
                      child: Text(
                        provider.userName.isNotEmpty ? provider.userName.substring(0, 2).toUpperCase() : 'CV',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            provider.nicho,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, AppProvider provider, int index, IconData icon, String title, {String? badge}) {
    final isSelected = provider.currentNavIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected ? const Color(0xFF1E1835) : Colors.transparent,
        leading: Icon(icon, color: isSelected ? const Color(0xFFA855F7) : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            : null,
        onTap: () {
          provider.setCurrentNavIndex(index);
          if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}