import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/providers/app_provider.dart';
import 'package:flutter_application_1/screens/automacao_trafego_screen.dart';
import 'package:flutter_application_1/screens/bot_tendencias_screen.dart';
import 'package:flutter_application_1/screens/planejador_conteudo_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:flutter_application_1/widgets/profile_modal.dart';

void main() {
  testWidgets('Test dynamic niche input and web search in BotTendenciasScreen', (WidgetTester tester) async {
    final provider = AppProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const BotTendenciasScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify initial elements
    expect(find.text('Defina o Tema de Pesquisa'), findsOneWidget);
    expect(find.text('Pesquisar na Web'), findsOneWidget);

    // 2. Change the theme
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    await tester.enterText(textFieldFinder, 'Finanças Pessoais');
    await tester.pumpAndSettle();

    // 3. Tap 'Pesquisar na Web'
    await tester.tap(find.text('Pesquisar na Web'));
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(provider.nicho, 'Finanças Pessoais');
    expect(find.textContaining('Trends em Alta para: Finanças Pessoais'), findsOneWidget);

    // 4. Tap 'Criar Roteiro'
    final criarRoteiroBtn = find.text('Criar Roteiro').first;
    await tester.tap(criarRoteiroBtn);
    await tester.pumpAndSettle();

    // Verify it redirected navigation to Chat (index 1) and registered script
    expect(provider.currentNavIndex, 1);
    expect(provider.scripts.length, 1);
  });

  testWidgets('Test MainNavigationScreen tab switching when Criar Roteiro is tapped', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final provider = AppProvider();
    provider.setCurrentNavIndex(2); // Start at Bot de Tendências

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const MainNavigationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify BotTendencias is active
    expect(find.text('Defina o Tema de Pesquisa'), findsOneWidget);

    // Tap Criar Roteiro
    final criarRoteiroBtn = find.text('Criar Roteiro').first;
    await tester.tap(criarRoteiroBtn);
    await tester.pumpAndSettle();

    // Verify navigation automatically switched to ChatBotScreen (index 1)
    expect(provider.currentNavIndex, 1);
  });

  testWidgets('Test PlanejadorConteudoScreen status toggling and filtering', (WidgetTester tester) async {
    final provider = AppProvider();
    provider.addScriptFromTrend('Roteiro Viral 1');

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const PlanejadorConteudoScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // In 'Todos', 1 item is shown with '● Pendente'
    expect(find.text('Roteiro Viral 1'), findsOneWidget);
    expect(find.text('● Pendente'), findsOneWidget);

    // Filter by 'Pendentes'
    await tester.tap(find.text('Pendentes (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Roteiro Viral 1'), findsOneWidget);

    // Filter by 'Concluídos'
    await tester.tap(find.text('Concluídos (0)'));
    await tester.pumpAndSettle();
    expect(find.text('Roteiro Viral 1'), findsNothing);

    // Go back to 'Pendentes'
    await tester.tap(find.text('Pendentes (1)'));
    await tester.pumpAndSettle();

    // Mark as completed by tapping the checkbox
    final checkboxFinder = find.byType(Checkbox);
    expect(checkboxFinder, findsOneWidget);
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    // Disappears from 'Pendentes'
    expect(find.text('Roteiro Viral 1'), findsNothing);
    expect(find.text('Nenhum roteiro pendente!'), findsOneWidget);

    // Go to 'Concluídos'
    await tester.tap(find.text('Concluídos (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Roteiro Viral 1'), findsOneWidget);
    expect(find.text('● Concluído'), findsOneWidget);
  });

  testWidgets('Test ProfileModal logout button redirects to WelcomeScreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final provider = AppProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(
          home: Scaffold(
            body: ProfileModal(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find and tap "Sair da Conta"
    final logoutBtn = find.text('Sair da Conta');
    expect(logoutBtn, findsOneWidget);
    await tester.ensureVisible(logoutBtn);
    await tester.tap(logoutBtn);
    await tester.pumpAndSettle();

    // Verify redirect to WelcomeScreen
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('Test AutomacaoTrafegoScreen shows success text after scheduling', (WidgetTester tester) async {
    final provider = AppProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const AutomacaoTrafegoScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Before clicking, no success message exists
    expect(find.text('Publicação agendada com sucesso!'), findsNothing);

    // Click "Agendar Publicação para 18:45"
    final agendarBtn = find.text('Agendar Publicação para 18:45');
    expect(agendarBtn, findsOneWidget);
    await tester.tap(agendarBtn);
    await tester.pumpAndSettle();

    // Success text must now appear on screen
    expect(find.text('Publicação agendada com sucesso!'), findsOneWidget);
    expect(find.text('● Status: Agendado para hoje às 18:45'), findsOneWidget);
  });
}
