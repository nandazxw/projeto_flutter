import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Esqueci minha senha',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textWhite),
              ),
              const SizedBox(height: 6),
              const Text(
                'Informe seu e-mail para receber as instruções de recuperação.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.3),
              ),
              const SizedBox(height: 32),
              const Text('E-mail', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'seuemail@gmail.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Enviar instruções'),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar para o login', style: TextStyle(color: AppColors.primaryPurple, fontSize: 13)),
                ),
              ),
              const Spacer(),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha:
                    0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_reset, size: 42, color: AppColors.primaryPurple),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}