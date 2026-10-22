import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/app_markdown_view.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Badge & Título
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA855F7).withValues(alpha: 0.3)),
                ),
                child: const Text(
                  '● Assistente ViralMind AI (Groq)',
                  style: TextStyle(color: Color(0xFFA855F7), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  children: [
                    TextSpan(text: 'Assistente de '),
                    TextSpan(text: 'Alavancagem Orgânica', style: TextStyle(color: Color(0xFFEC4899))),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Container Principal do Chat
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11131F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      // Lista de Mensagens
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            final msg = provider.messages[index];
                            return _buildMessageItem(context, msg);
                          },
                        ),
                      ),

                      // Indicador de "Pensando..." com estilo sutil e moderno
                      if (provider.isSendingMessage)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161828),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFA855F7).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFA855F7)),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Estruturando roteiro e estratégia viral...',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 10),

                      // Campo de Input com Design Elevado
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF090A10),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                enabled: !provider.isSendingMessage,
                                maxLines: null,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (val) {
                                  if (val.trim().isNotEmpty) {
                                    provider.sendMessage(val.trim());
                                    _controller.clear();
                                    _scrollToBottom();
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Pergunte sobre ganchos, algoritmos ou peça um roteiro...',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFA855F7),
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 20),
                              onPressed: provider.isSendingMessage
                                  ? null
                                  : () {
                                      final text = _controller.text.trim();
                                      if (text.isNotEmpty) {
                                        provider.sendMessage(text);
                                        _controller.clear();
                                        _scrollToBottom();
                                      }
                                    },
                            ),
                          ],
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

  // Renderizador de balão de mensagem estilizado
  Widget _buildMessageItem(BuildContext context, ChatMessage msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar do Bot
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(top: 2, right: 10),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
          ],

          // Balão com suporte a Markdown formatado
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 620),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFFA855F7) : const Color(0xFF181A2A),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: isUser ? Colors.transparent : Colors.white.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: isUser
                  ? SelectableText(
                      msg.text,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : AppMarkdownView(data: msg.text),
            ),
          ),

          // Avatar do Usuário
          if (isUser) ...[
            Container(
              margin: const EdgeInsets.only(top: 2, left: 10),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2E264D),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
