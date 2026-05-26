import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:mydiet/app/data/controllers/sessao_controller.dart';
import 'package:mydiet/app/pages/main_homepage.dart';
import 'package:mydiet/app/data/controllers/auth_controller.dart';
import 'package:mydiet/app/widgets/auth_widgets.dart';
import 'package:mydiet/app/pages/userPages/login_page.dart';


class CadastroPage extends StatefulWidget {
  
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _nomeUsuarioController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _nomeUsuarioController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit(SessionController sessionController) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final nome = _nomeController.text.trim();
    final nomeUsuario = _nomeUsuarioController.text.trim();
    final pin = int.parse(_pinController.text);

    // 🆕 Validação básica antes de enviar
    if (nome.isEmpty || nomeUsuario.isEmpty) {
      _showError('Por favor, preencha todos os campos');
      return;
    }

    final success = await sessionController.registrar(nome, nomeUsuario, pin);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainHome()),
      );
    } else {
      _showError(sessionController.errorMessage ?? 'Erro ao registrar');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionController>(
      builder: (context, sessionController, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Criar Conta')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: AuthCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AuthTextField(
                          controller: _nomeController,
                          label: 'Nome Completo',
                          enabled: !sessionController.isLoading,
                          prefixIcon: Icons.person_outline,
                          validator: AuthValidators.validateNome,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _nomeUsuarioController,
                          label: 'Nome de Usuário',
                          enabled: !sessionController.isLoading,
                          prefixIcon: Icons.alternate_email,
                          validator: AuthValidators.validateNomeUsuario,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _pinController,
                          label: 'PIN',
                          enabled: !sessionController.isLoading,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.lock_outline,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: AuthValidators.validatePin,
                        ),
                        const SizedBox(height: 32),
                        AuthPrimaryButton(
                          label: 'Criar Conta',
                          isLoading: sessionController.isLoading,
                          onPressed: () => _submit(sessionController),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: sessionController.isLoading
                              ? null
                              : () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginPage()),
                                  ),
                          child: const Text('Já tem conta? Faça login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}