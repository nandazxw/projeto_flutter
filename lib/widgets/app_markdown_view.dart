import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Preprocessa strings Markdown:
/// - Substitui tags HTML por quebras reais.
/// - Converte tabelas (| ... |) em blocos de texto fluido adaptados para celular,
///   mantendo o formato natural de leitura e tipografia sem quebrar a tela.
String sanitizeMarkdown(String rawText) {
  if (rawText.isEmpty) return rawText;

  // 1. Substitui tags HTML <br> ou <br/> por quebras de linha reais
  var processed = rawText
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll('&lt;br&gt;', '\n')
      .replaceAll('&lt;br/&gt;', '\n')
      .replaceAll('&lt;br /&gt;', '\n');

  if (!processed.contains('|')) return processed;

  // 2. Remove a estrutura de tabela em grade e transforma em texto corrido e estruturado
  final lines = processed.split('\n');
  final result = <String>[];
  final tableRows = <List<String>>[];
  bool inTable = false;

  void flushTable() {
    if (tableRows.isEmpty) return;

    if (tableRows.length == 1) {
      result.add(tableRows[0].join(' — '));
      result.add('');
      tableRows.clear();
      return;
    }

    final headers = tableRows[0];
    final dataRows = tableRows.sublist(1);

    for (final row in dataRows) {
      if (row.isEmpty) continue;

      if (row.length == 1) {
        result.add(row[0]);
      } else if (row.length == 2) {
        final col1 = row[0];
        final col2 = row[1];
        // Se já tiver número ou título na primeira coluna
        if (RegExp(r'^\d+[\.\)]').hasMatch(col1)) {
          result.add('$col1: $col2');
        } else {
          result.add('• **$col1**: $col2');
        }
      } else {
        final title = row[0];
        final details = <String>[];
        for (int i = 1; i < row.length; i++) {
          final h = (i < headers.length && headers[i].isNotEmpty && !headers[i].startsWith('-')) 
              ? '${headers[i]}: ' 
              : '';
          details.add('$h${row[i]}');
        }
        if (RegExp(r'^\d+[\.\)]').hasMatch(title)) {
          result.add('$title — ${details.join(' | ')}');
        } else {
          result.add('• **$title**: ${details.join(' — ')}');
        }
      }
    }
    result.add('');
    tableRows.clear();
  }

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trim();
    final isPipeRow = trimmed.startsWith('|') && trimmed.endsWith('|') && trimmed.length > 2;

    if (isPipeRow) {
      // Linha divisora Markdown (|---|---|)
      final isDivider = trimmed.replaceAll(RegExp(r'[|\s\-:]'), '').isEmpty;
      if (isDivider) {
        continue;
      }

      final rawCells = trimmed.substring(1, trimmed.length - 1).split('|');
      final cells = rawCells.map((c) => c.trim()).toList();

      if (cells.any((c) => c.isNotEmpty)) {
        tableRows.add(cells);
        inTable = true;
      }
    } else {
      if (inTable) {
        flushTable();
        inTable = false;
      }
      result.add(line);
    }
  }

  if (inTable) {
    flushTable();
  }

  return result.join('\n');
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
