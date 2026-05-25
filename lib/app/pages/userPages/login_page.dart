import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
 
import 'package:mydiet/app/controllers/sessao_controller.dart';
import 'package:mydiet/app/pages/main_homepage.dart';
import 'package:mydiet/app/controllers/auth_controller.dart';
import 'package:mydiet/app/widgets/auth_widgets.dart';
import 'package:mydiet/app/pages/userPages/cadastro_page.dart';

 
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
 
  @override
  State<LoginPage> createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _pinController = TextEditingController();
 
  @override
  void dispose() {
    _nomeController.dispose();
    _pinController.dispose();
    super.dispose();
  }
 
  Future<void> _submit(SessionController sessionController) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
 
    final nome = _nomeController.text.trim();
    final pin = int.parse(_pinController.text);
 
    final success = await sessionController.login(nome, pin);
 
    if (!mounted) return;
 
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainHome()),
      );
    } else {
      _showError(sessionController.errorMessage ?? 'Erro ao fazer login');
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
 
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CadastroPage()),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Consumer<SessionController>(
      builder: (context, sessionController, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
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
                          label: 'Nome de usuário',
                          enabled: !sessionController.isLoading,
                          prefixIcon: Icons.person_outline,
                          validator: AuthValidators.validateNome,
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
                          label: 'Entrar',
                          isLoading: sessionController.isLoading,
                          onPressed: () => _submit(sessionController),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: sessionController.isLoading
                              ? null
                              : _navigateToRegister,
                          child: const Text('Não tem conta? Registre-se'),
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