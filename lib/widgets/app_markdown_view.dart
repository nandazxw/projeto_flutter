import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Preprocessa strings Markdown para garantir compatibilidade com tabelas e tags HTML
/// geradas por modelos de IA (ex: Groq, GPT, Claude).
String sanitizeMarkdown(String rawText) {
  if (rawText.isEmpty) return rawText;

  // 1. Substitui tags HTML <br> ou <br/> por quebras de linha reais
  var processed = rawText
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll('&lt;br&gt;', '\n')
      .replaceAll('&lt;br/&gt;', '\n')
      .replaceAll('&lt;br /&gt;', '\n');

  // 2. Corrige tabelas sem linha separadora de cabeçalho (|---|---|)
  // Alguns modelos geram apenas linhas iniciando e terminando com pipe '|'
  final lines = processed.split('\n');
  final newLines = <String>[];
  bool inTable = false;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trim();
    final isPipeRow = trimmed.startsWith('|') && trimmed.endsWith('|');

    if (isPipeRow) {
      if (!inTable) {
        inTable = true;
        newLines.add(line);
        // Verifica se a próxima linha já é um divisor (|---|)
        final nextLine = (i + 1 < lines.length) ? lines[i + 1].trim() : '';
        final isNextDivider = nextLine.startsWith('|') &&
            nextLine.contains('---') &&
            nextLine.endsWith('|');

        if (!isNextDivider) {
          // Sintetiza uma linha divisora com o mesmo número de colunas
          final cellCount = trimmed.split('|').length - 2;
          if (cellCount > 0) {
            final divider = '| ${List.filled(cellCount, '---').join(' | ')} |';
            newLines.add(divider);
          }
        }
      } else {
        newLines.add(line);
      }
    } else {
      inTable = false;
      newLines.add(line);
    }
  }

  return newLines.join('\n');
}

/// Widget unificado de Markdown com suporte a rolagem horizontal em tabelas
/// e preservação total de tipografia e estilo.
class AppMarkdownView extends StatelessWidget {
  final String data;
  final bool selectable;
  final double fontSize;

  const AppMarkdownView({
    super.key,
    required this.data,
    this.selectable = true,
    this.fontSize = 14.5,
  });

  @override
  Widget build(BuildContext context) {
    final sanitizedData = sanitizeMarkdown(data);

    return MarkdownBody(
      data: sanitizedData,
      selectable: selectable,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: fontSize,
          height: 1.6,
          color: const Color(0xFFE2E8F0),
          letterSpacing: 0.2,
        ),
        strong: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        em: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontStyle: FontStyle.italic,
        ),
        h1: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA855F7),
          height: 1.5,
        ),
        h2: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA855F7),
          height: 1.5,
        ),
        h3: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFFEC4899),
          height: 1.4,
        ),
        listBullet: const TextStyle(
          color: Color(0xFFA855F7),
          fontSize: 14,
        ),
        code: const TextStyle(
          backgroundColor: Color(0xFF090A10),
          color: Color(0xFF38BDF8),
          fontSize: 13,
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: const Color(0xFF090A10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        blockquote: const TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          border: const Border(
            left: BorderSide(color: Color(0xFFA855F7), width: 3),
          ),
          color: const Color(0xFF090A10).withValues(alpha: 0.5),
        ),
        tableHead: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        tableBody: TextStyle(
          color: const Color(0xFFE2E8F0),
          fontSize: fontSize - 1.5,
          height: 1.4,
        ),
        tableBorder: TableBorder.all(
          color: Colors.white12,
          width: 1,
        ),
        tableColumnWidth: const IntrinsicColumnWidth(),
        tableCellsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        tableCellsDecoration: const BoxDecoration(
          color: Color(0xFF0D0E17),
        ),
      ),
    );
  }
}
