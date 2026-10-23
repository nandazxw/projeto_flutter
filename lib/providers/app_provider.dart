import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ScriptItem {
  final String id;
  final String title;
  final String content;
  final String status; // 'Pendente' ou 'Concluído'
  final DateTime createdAt;

  ScriptItem({
    required this.id,
    required this.title,
    this.content = '',
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TrendModel {
  final String titulo;
  final String descricao;
  final String categoria;
  final int growthScore;
  final String hook;
  final String tags;

  TrendModel({
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.growthScore,
    required this.hook,
    required this.tags,
  });

  Map<String, String> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'crescimento': '+$growthScore% retenção',
      'categoria': categoria,
      'hook': hook,
      'tags': tags,
    };
  }
}

class AppProvider extends ChangeNotifier {
  // Estado de Autenticação & Usuário
  String _userName = 'Criador Viral';
  String _userEmail = '';
  String _userHandle = '@criador_viral';
  String _nicho = 'Tecnologia';
  String _plataforma = 'Instagram Reels';
  String _tomDeVoz = 'Educativo & Direto';
  String _estrategia = 'Gancho de Curiosidade (3s)';
  bool _isLoggedIn = false;

  // Métricas de engajamento acumulado
  int _mensagensTrocadas = 0;
  int _totalCaracteresDigitados = 0;
  int _roteirosConcluidos = 0;

  // Estado do Chat
  bool _isSendingMessage = false;
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Olá! Sou o teu assistente de alavancagem orgânica do ViralMind. Digite qualquer ideia, nicho ou peça um roteiro para alavancarmos seu conteúdo com IA!',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  // Navegação Global
  int _currentNavIndex = 0;

  // Estado de Agendamento
  String _selectedScheduleTime = '18:45';
  bool _isScheduling = false;

  // Estado do Planejador (Exclusivamente Roteiros/Ideias gerados pelo Chat Bot)
  final List<ScriptItem> _scripts = [];

  // Estado do Bot de Tendências
  bool _isLoadingTendencias = false;
  List<TrendModel> _tendencias = [
    TrendModel(
      titulo: 'Como usar IA para acelerar a produção de conteúdo no nicho atual',
      descricao: 'Formatos rápidos demonstrando o uso de ferramentas inteligentes.',
      categoria: 'Formato de Alto Impacto',
      growthScore: 120,
      hook: 'Pare agora se você ainda perde horas criando conteúdo sozinho...',
      tags: '#ia, #criatividade, #viral',
    ),
    TrendModel(
      titulo: '3 Hacks de viralização essenciais para criadores em 2026',
      descricao: 'Estratégias avançadas de retenção nos primeiros 3 segundos.',
      categoria: 'Lista / Hacks Virais',
      growthScore: 95,
      hook: 'Quase ninguém percebeu essa mudança no algoritmo esta semana...',
      tags: '#algoritmo, #crescimento, #dicas',
    ),
  ];

  AppProvider() {
    _initApp();
  }

  Future<void> _initApp() async {
    final token = await ApiService.getToken();
    if (token != null && token.isNotEmpty) {
      _isLoggedIn = true;
      final storedUser = await ApiService.getStoredUser();
      if (storedUser != null) {
        _userName = storedUser['name'] ?? _userName;
        _userEmail = storedUser['email'] ?? '';
        _userHandle = '@${_userName.toLowerCase().replaceAll(' ', '_')}';
      }
      notifyListeners();
      analisarTendenciasWeb(_nicho);
      carregarHistoricoChat();
    }
  }

  // Getters
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userHandle => _userHandle;
  String get nicho => _nicho;
  String get plataforma => _plataforma;
  String get tomDeVoz => _tomDeVoz;
  String get estrategia => _estrategia;
  bool get isLoggedIn => _isLoggedIn;
  int get mensagensTrocadas => _mensagensTrocadas;
  int get totalCaracteresDigitados => _totalCaracteresDigitados;
  int get roteirosConcluidos => _roteirosConcluidos;
  List<ChatMessage> get messages => _messages;
  bool get isSendingMessage => _isSendingMessage;
  int get currentNavIndex => _currentNavIndex;
  String get selectedScheduleTime => _selectedScheduleTime;
  bool get isScheduling => _isScheduling;
  List<ScriptItem> get scripts => _scripts;
  List<Map<String, String>> get tendencias => _tendencias.map((t) => t.toMap()).toList();
  List<TrendModel> get rawTendencias => _tendencias;
  bool get isLoadingTendencias => _isLoadingTendencias;

  // ==========================================
  // CÁLCULOS DINÂMICOS DE ENGAJAMENTO
  // ==========================================

  double get mediaScoreTrends {
    if (_tendencias.isEmpty) return 75.0;
    final total = _tendencias.fold<int>(0, (sum, t) => sum + t.growthScore);
    return total / _tendencias.length;
  }

  double get calculatedEngagementRate {
    double base = 3.2;
    double chatFactor = (_mensagensTrocadas * 0.22).clamp(0.0, 3.5);
    double detailFactor = (_totalCaracteresDigitados / 400).clamp(0.0, 2.0);
    double trendBonus = ((mediaScoreTrends - 70) * 0.05).clamp(0.0, 3.0);
    double scriptBonus = (_roteirosConcluidos * 0.6).clamp(0.0, 3.0);

    return (base + chatFactor + detailFactor + trendBonus + scriptBonus).clamp(2.5, 25.0);
  }

  int get calculatedReach {
    int base = 4200;
    int chatReach = _mensagensTrocadas * 850;
    int inputDetailReach = (_totalCaracteresDigitados * 8).clamp(0, 15000);
    int trendReach = _tendencias.fold<int>(0, (sum, t) => sum + (t.growthScore * 35));
    int scriptsReach = (_roteirosConcluidos * 3400) + ((_scripts.length - _roteirosConcluidos) * 800);

    return base + chatReach + inputDetailReach + trendReach + scriptsReach;
  }

  int get calculatedHealthScore {
    int score = 40;
    score += (_mensagensTrocadas * 4).clamp(0, 25);
    score += (_totalCaracteresDigitados > 100 ? 10 : 3);
    score += (_roteirosConcluidos * 7).clamp(0, 20);
    score += ((mediaScoreTrends / 10).round()).clamp(5, 15);
    return score.clamp(20, 100);
  }

  // ==========================================
  // AUTENTICAÇÃO
  // ==========================================

  void _resetChatState() {
    _messages.clear();
    _messages.add(ChatMessage(
      text: 'Olá! Sou o teu assistente de alavancagem orgânica do ViralMind. Digite qualquer ideia, nicho ou peça um roteiro para alavancarmos seu conteúdo com IA!',
      isUser: false,
      timestamp: DateTime.now(),
    ));
    _scripts.clear();
    _roteirosConcluidos = 0;
    _mensagensTrocadas = 0;
    _totalCaracteresDigitados = 0;
  }

  Future<void> login(String email, String password) async {
    final res = await ApiService.login(email, password);
    _isLoggedIn = true;
    _resetChatState();
    if (res['user'] != null) {
      final user = res['user'];
      _userName = user['name'] ?? _userName;
      _userEmail = user['email'] ?? email;
      _userHandle = '@${_userName.toLowerCase().replaceAll(' ', '_')}';
    }
    notifyListeners();
    analisarTendenciasWeb(_nicho);
    await carregarHistoricoChat();
  }

  Future<void> loginWithGoogle({required String email, String? name, String? idToken}) async {
    final res = await ApiService.googleLogin(email: email, name: name, idToken: idToken);
    _isLoggedIn = true;
    _resetChatState();
    if (res['user'] != null) {
      final user = res['user'];
      _userName = user['name'] ?? (name ?? _userName);
      _userEmail = user['email'] ?? email;
      _userHandle = '@${_userName.toLowerCase().replaceAll(' ', '_')}';
    }
    notifyListeners();
    analisarTendenciasWeb(_nicho);
    await carregarHistoricoChat();
  }

  Future<void> register(String name, String email, String password) async {
    await ApiService.register(name, email, password);
    await login(email, password);
  }

  Future<void> logout() async {
    await ApiService.logout();
    _isLoggedIn = false;
    _resetChatState();
    notifyListeners();
  }

  void setCurrentNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setNicho(String nicho) {
    _nicho = nicho;
    notifyListeners();
  }

  // ==========================================
  // CHAT DINÂMICO & EXTRAÇÃO AUTOMÁTICA DE ROTEIROS
  // ==========================================

  int _scriptCounter = 0;

  // Analisa se a mensagem/resposta contém ou configura um roteiro/ideia e extrai para o planejador
  void _detectAndExtractScriptFromChat(String userPrompt, String botReply) {
    final promptLower = userPrompt.toLowerCase();
    final replyLower = botReply.toLowerCase();

    final isScriptOrIdea = promptLower.contains('roteiro') ||
        promptLower.contains('script') ||
        promptLower.contains('ideia') ||
        promptLower.contains('crie') ||
        promptLower.contains('tema') ||
        promptLower.contains('vídeo') ||
        promptLower.contains('video') ||
        replyLower.contains('roteiro') ||
        replyLower.contains('gancho') ||
        replyLower.contains('cta');

    if (isScriptOrIdea) {
      // Extrai um título conciso e representativo
      String title = userPrompt.trim();
      if (title.toLowerCase().startsWith('crie um roteiro viral completo para o tema:')) {
        title = title.replaceAll(RegExp(r'crie um roteiro viral completo para o tema:\s*', caseSensitive: false), '');
        final parts = title.split('", focado no nicho');
        if (parts.isNotEmpty) {
          title = parts[0].replaceAll('"', '').trim();
        }
      } else if (title.length > 70) {
        // Pega a primeira linha ou resume
        final firstLine = title.split('\n').first.trim();
        title = firstLine.length > 70 ? '${firstLine.substring(0, 67)}...' : firstLine;
      }

      // Evita duplicidade com o mesmo título exato
      final alreadyExists = _scripts.any((s) => s.title.toLowerCase() == title.toLowerCase());
      if (!alreadyExists && title.isNotEmpty) {
        _scriptCounter++;
        _scripts.insert(
          0,
          ScriptItem(
            id: '${DateTime.now().microsecondsSinceEpoch}_$_scriptCounter',
            title: title,
            content: botReply,
            status: 'Pendente',
            createdAt: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> carregarHistoricoChat() async {
    try {
      final history = await ApiService.getChatHistory();
      if (history.isNotEmpty) {
        _messages.clear();
        for (final item in history) {
          final userMsg = item['message']?.toString() ?? '';
          final assistantMsg = item['response']?.toString() ?? '';

          if (userMsg.isNotEmpty) {
            _messages.add(ChatMessage(
              text: userMsg,
              isUser: true,
              timestamp: DateTime.now(),
            ));
          }
          if (assistantMsg.isNotEmpty) {
            _messages.add(ChatMessage(
              text: assistantMsg,
              isUser: false,
              timestamp: DateTime.now(),
            ));
          }

          if (userMsg.isNotEmpty && assistantMsg.isNotEmpty) {
            _detectAndExtractScriptFromChat(userMsg, assistantMsg);
          }
        }
        _mensagensTrocadas = _messages.where((m) => m.isUser).length;
        _roteirosConcluidos = _scripts.where((s) => s.status == 'Concluído').length;
        notifyListeners();
      } else {
        // Para novas contas ou histórico limpo, garante o estado inicial sem resquícios
        _resetChatState();
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> limparHistoricoChat() async {
    try {
      await ApiService.clearChatHistory();
    } catch (_) {}
    _resetChatState();
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    _messages.add(ChatMessage(text: cleanText, isUser: true, timestamp: DateTime.now()));
    _mensagensTrocadas++;
    _totalCaracteresDigitados += cleanText.length;
    _isSendingMessage = true;
    notifyListeners();

    try {
      final botReply = await ApiService.sendChatMessage(cleanText);
      _messages.add(ChatMessage(
        text: botReply,
        isUser: false,
        timestamp: DateTime.now(),
      ));

      // Extrai a ideia/roteiro gerada pelo chat automaticamente para o Planejador
      _detectAndExtractScriptFromChat(cleanText, botReply);
    } catch (e) {
      final isRoteiro = cleanText.toLowerCase().contains('roteiro') || cleanText.toLowerCase().contains('script');
      final reply = isRoteiro
          ? '🎬 **Roteiro Estratégico Viral Gerado para:** "$cleanText"\n\n'
            '📌 **1. Gancho de Curiosidade (0 a 3s):**\n"Você está cometendo esse erro em $cleanText e isso está matando o teu alcance..."\n\n'
            '💡 **2. Desenvolvimento & Retenção (3 a 25s):**\n- Explique o ponto principal em 2 etapas práticas.\n- Use corte rápido de imagem a cada 4 segundos.\n\n'
            '🚀 **3. Chamada para Ação (CTA):**\n"Comenta aqui a tua maior dúvida e salva esse vídeo para aplicar!"'
          : '💡 Analisei a tua mensagem sobre **"$cleanText"** no nicho de **$_nicho**!\n\n'
            'Para gerar maior engajamento com esse tema no $_plataforma, recomendo usar um gancho de contraste nos primeiros 3 segundos e abordar a solução com dados práticos.';

      _messages.add(ChatMessage(
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      ));

      _detectAndExtractScriptFromChat(cleanText, reply);
    } finally {
      _isSendingMessage = false;
      notifyListeners();
    }
  }

  // ==========================================
  // GESTÃO DOS ROTEIROS DO PLANEJADOR
  // ==========================================

  void toggleScriptStatus(String id) {
    final index = _scripts.indexWhere((item) => item.id == id);
    if (index != -1) {
      final current = _scripts[index];
      final newStatus = current.status == 'Concluído' ? 'Pendente' : 'Concluído';
      _scripts[index] = ScriptItem(
        id: current.id,
        title: current.title,
        content: current.content,
        status: newStatus,
        createdAt: current.createdAt,
      );
      _roteirosConcluidos = _scripts.where((s) => s.status == 'Concluído').length;
      notifyListeners();
    }
  }

  void deleteScript(String id) {
    _scripts.removeWhere((item) => item.id == id);
    _roteirosConcluidos = _scripts.where((s) => s.status == 'Concluído').length;
    notifyListeners();
  }

  // Método auxiliar mantido para compatibilidade e testes
  void addScriptFromTrend(String title) {
    if (title.trim().isEmpty) return;
    final alreadyExists = _scripts.any((s) => s.title.toLowerCase() == title.trim().toLowerCase());
    if (!alreadyExists) {
      _scriptCounter++;
      _scripts.insert(
        0,
        ScriptItem(
          id: '${DateTime.now().microsecondsSinceEpoch}_$_scriptCounter',
          title: title.trim(),
          content: 'Ideia encaminhada diretamente para desenvolvimento com a IA.',
          status: 'Pendente',
        ),
      );
      notifyListeners();
    }
  }

  // Dispara o pedido de roteiro diretamente para o bot do chat e redireciona
  void criarRoteiroComBot(String trendTitle) {
    sendMessage('Crie um roteiro viral completo para o tema: "$trendTitle", focado no nicho de "$_nicho".');
    _currentNavIndex = 1; // Redireciona diretamente para a tela do Chat
    notifyListeners();
  }

  // ==========================================
  // TRENDS DINÂMICAS DA WEB VIA IA
  // ==========================================

  Future<void> analisarTendenciasWeb([String? customNicho]) async {
    final searchTheme = (customNicho != null && customNicho.trim().isNotEmpty)
        ? customNicho.trim()
        : _nicho.trim();

    _nicho = searchTheme;
    _isLoadingTendencias = true;
    _totalCaracteresDigitados += searchTheme.length;
    notifyListeners();

    try {
      List<Map<String, dynamic>> rawTrends = [];
      try {
        rawTrends = await ApiService.generateTrends(niche: searchTheme, count: 5);
      } catch (_) {
        rawTrends = await ApiService.getTrends(niche: searchTheme, limit: 6);
      }

      if (rawTrends.isNotEmpty) {
        _tendencias = rawTrends.map((t) {
          final growthRaw = t['growth_score'];
          int score = 88;
          if (growthRaw is int) {
            score = growthRaw;
          } else if (growthRaw is num) {
            score = growthRaw.toInt();
          }

          return TrendModel(
            titulo: (t['title'] ?? 'Tendência em Alta').toString(),
            descricao: (t['description'] ?? 'Ideia de alto engajamento mapeada na web').toString(),
            categoria: (t['category'] ?? searchTheme).toString(),
            growthScore: score,
            hook: (t['suggested_hook'] ?? '').toString(),
            tags: (t['suggested_tags'] ?? '').toString(),
          );
        }).toList();
      } else {
        _gerarTrendsDinamicasLocais(searchTheme);
      }
    } catch (e) {
      _gerarTrendsDinamicasLocais(searchTheme);
    } finally {
      _isLoadingTendencias = false;
      notifyListeners();
    }
  }

  void _gerarTrendsDinamicasLocais(String tema) {
    final scoreBase = 85 + (tema.length % 12);
    _tendencias = [
      TrendModel(
        titulo: 'Como alavancar resultados expressivos com $tema em 2026',
        descricao: 'Análise aprofundada dos vídeos com maior retenção no nicho de $tema.',
        categoria: 'Tutorial Estratégico',
        growthScore: (scoreBase + 8).clamp(70, 99),
        hook: 'O que ninguém te conta sobre $tema nos primeiros 3 segundos...',
        tags: '#${tema.toLowerCase().replaceAll(' ', '')}, #viral, #alta',
      ),
      TrendModel(
        titulo: 'Os 3 Maiores Erros cometidos em $tema que derrubam o engajamento',
        descricao: 'Formato de quebra de objeção gerando alto volume de comentários.',
        categoria: 'Quebra de Objeção',
        growthScore: (scoreBase + 5).clamp(70, 98),
        hook: 'Se você ainda faz isso ao criar sobre $tema, pare imediatamente!',
        tags: '#dicas, #erros, #crescimento',
      ),
      TrendModel(
        titulo: 'Estratégia Secreta de Retenção para $tema no $_plataforma',
        descricao: 'Técnica dos ganchos visuais para manter o público até o final.',
        categoria: 'Algoritmo & Retenção',
        growthScore: (scoreBase + 2).clamp(70, 96),
        hook: 'Esse detalhe em vídeos de $tema dobra o tempo médio de visualização...',
        tags: '#engajamento, #retencao, #algoritmo',
      ),
      TrendModel(
        titulo: 'Nova atualização e o impacto direto no nicho de $tema',
        descricao: 'Conteúdo de notícia quente com alto índice de compartilhamento.',
        categoria: 'Notícia em Alta',
        growthScore: (scoreBase + 10).clamp(75, 100),
        hook: 'Você viu o que mudou no nicho de $tema esta semana?',
        tags: '#novidade, #tendencia, #compartilhe',
      ),
    ];
  }

  // ==========================================
  // AGENDAMENTO
  // ==========================================

  void selectSchedule(String time) {
    _selectedScheduleTime = time;
    notifyListeners();
  }

  Future<bool> confirmarAgendamento() async {
    _isScheduling = true;
    notifyListeners();
    try {
      await ApiService.createSchedule(
        niche: _nicho,
        targetTimeStr: _selectedScheduleTime,
        title: 'Post automático para $_nicho',
      );
      _isScheduling = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isScheduling = false;
      notifyListeners();
      return false;
    }
  }

  void updateProfile({
    required String name,
    required String handle,
    required String nicho,
    required String plataforma,
    required String tomDeVoz,
    required String estrategia,
  }) {
    _userName = name;
    _userHandle = handle;
    _nicho = nicho;
    _plataforma = plataforma;
    _tomDeVoz = tomDeVoz;
    _estrategia = estrategia;
    notifyListeners();
  }
}
